# Thorium Patch Manifest Generator

Batch script for generating and managing patch file manifests with SHA-256 hashing for the Thorium WoW server.

## Features

- **Automated Hashing** - Generates SHA-256 hashes for all Patch-*.mpq files
- **JSON Manifest** - Creates a structured manifest with file metadata
- **File Metadata** - Includes file size and download URLs
- **Timestamp Tracking** - Logs generation time for manifest versioning
- **Batch Processing** - Scans and processes multiple patch files automatically

## Usage

```bash
generate-manifest.bat
```

Scans the current directory for all `Patch-*.mpq` files and generates `patch-manifest.json` with:
- File names and URLs
- File sizes in bytes
- SHA-256 hashes for integrity verification
- Manifest version and generation timestamp

## Output Format

```json
{
  "manifestVersion": 1,
  "baseUrl": "https://www.thorium-reforged.org/Downloads/",
  "generatedAt": "04/01/2026 06:25:31",
  "files": [
    {
      "name": "Patch-8.mpq",
      "url": "Patch-8.mpq",
      "size": 1078235456,
      "sha256": "abc123..."
    }
  ]
}
```

## Requirements

- Windows batch environment
- PowerShell (for SHA-256 calculation)
- Patch files named `Patch-*.mpq`

## Notes

- Generate manifest whenever patch files are updated
- SHA-256 hashes ensure patch integrity during distribution
- Manifest is consumed by the launcher to verify downloads
