import os
import caris.coverage

def export_csar_to_geotiff(input_folder):
    # Ensure output folder exists
    output_folder = input_folder  # Save GeoTIFFs in the same folder as CSARs

    for filename in os.listdir(input_folder):
        if filename.lower().endswith('.csar'):
            csar_path = os.path.join(input_folder, filename)
            print(f"Processing {csar_path}...")

            # Open the CSAR coverage
            coverage = caris.coverage.open_coverage(csar_path)
            if coverage is None:
                print(f"Failed to open {csar_path}")
                continue

            # Set output GeoTIFF path
            out_name = os.path.splitext(filename)[0] + ".tif"
            out_path = os.path.join(output_folder, out_name)

            # Export as floating-point GeoTIFF
            coverage.export(out_path, format="GeoTIFF", data_type="float32")
            print(f"Exported to {out_path}")

if __name__ == "__main__":
    input_folder = input("Enter the path to the folder containing CSAR files: ").strip()
    if not os.path.isdir(input_folder):
        print(f"ERROR: {input_folder} is not a valid directory.")
    else:
        export_csar_to_geotiff(input_folder)
