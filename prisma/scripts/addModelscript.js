import fs from "fs";
import path from "path";
import { execSync } from "child_process";

const schemaPath = path.resolve("./prisma/schema.prisma");

async function main() {
  // 🟦 Step 1: Get model name from CLI args
  const modelArg = process.argv[2]; // e.g. node addDynamicLogModel.js erode_logs
  if (!modelArg) {
    console.error("❌ Please provide a model name, e.g. `node addDynamicLogModel.js erode_logs`");
    process.exit(1);
  }

  // Model + relation names are the same
  const modelName = modelArg.trim();
  const relationName = modelArg.trim();

  console.log(`🛠 Creating model: ${modelName}`);

  let schemaContent = fs.readFileSync(schemaPath, "utf8");

  // 🟩 Step 2: Check if model already exists
  if (schemaContent.includes(`model ${modelName}`)) {
    console.log(`⚠️ Model ${modelName} already exists in schema.prisma`);
    process.exit(0);
  }

  // 🟨 Step 3: Model template (Your final version)
  const modelTemplate = `
model ${modelName} {
  id                        Int           @id        @default(autoincrement())
  entry_date                DateTime
  organization_id           Int?
  organization_name         String

  vehicle_id                Int?
  vehicle_number            String
  category_id               Int?
  category_name             String
  measure_unit              UnitsOfMeasure
  driver_id                 Int?
  driver_name               String
  bunk_id                   Int?
  fuel_bunk_name            String

  start_reading             Decimal
  end_reading               Decimal
  reading_difference        Decimal

  gps_readings              Decimal?

  previous_excess_fuel      Decimal?
  fuel_filled               Decimal
  fuel_filled_date          DateTime
  fuel_type                 FuelTypes
  total_fuel_cost           Decimal

  trip_count                Int
  remarks                   String      @db.Text

  images                    Json?

  vehicle                   Vehicles            @relation(fields: [vehicle_id],references: [id],onDelete: SetNull)
  organization              Organizations       @relation(fields: [organization_id],references: [id],onDelete: SetNull)
  category                  VehicleCategories   @relation(fields: [category_id],references: [id],onDelete: SetNull)
  driver                    Drivers             @relation(fields: [driver_id],references: [id],onDelete: SetNull)
  bunk                      FuelBunks           @relation(fields: [bunk_id],references: [id],onDelete: SetNull)
}
`;

  // 🟦 Step 4: Append model to schema
  schemaContent += `\n${modelTemplate}`;

  // 🟨 Step 5: Add relation to multiple models
  const targetModels = [
    "Vehicles",
    "Organizations",
    "VehicleCategories",
    "Drivers",
    "FuelBunks",
  ];

  targetModels.forEach((target) => {
    const match = schemaContent.match(new RegExp(`model ${target} {([\\s\\S]*?)}`));
    if (match && !match[1].includes(`${relationName} `)) {
      schemaContent = schemaContent.replace(
        new RegExp(`model ${target} {([\\s\\S]*?)}`),
        (m, inner) => `model ${target} {${inner}\n  ${relationName}   ${modelName}[]\n}`
      );
      console.log(`✅ Added ${relationName} relation to ${target} model.`);
    }
  });

  // 🟩 Step 6: Save schema
  fs.writeFileSync(schemaPath, schemaContent);
  console.log(`✅ Added model ${modelName} and relations to schema.prisma`);

  // 🟦 Step 7: Run Prisma migration
  const migrationName = `add_${modelName}_model`;
  execSync(`npx prisma migrate dev --name ${migrationName} --skip-seed`, {
    stdio: "inherit",
  });

  // 🟩 Step 8: Generate Prisma client
  execSync(`npx prisma generate`, { stdio: "inherit" });
  console.log(`🎉 Prisma client generated successfully.`);

  console.log(`✅ All done! ${modelName} is ready to use in your project.`);
}

// Run the script
main().catch((err) => {
  console.error("❌ Error:", err);
  process.exit(1);
});
