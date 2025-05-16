# cTAKES Docker Project

This project provides a Dockerized environment for running [Apache cTAKES](https://ctakes.apache.org/), a natural language processing system for extraction of information from electronic medical record clinical free-text.

## Features

- **cTAKES 6.0.0** installed from official releases
- **ctakes-resources** dictionary included
- Runs a basic cTAKES pipeline on a sample input file
- Output is written to `/output` in XMI format
- Easily configurable for custom input, output, and pipeline files

---

## Getting Started

### 1. Build the Docker Image

```sh
docker build -t ctakes-docker .
```

---

### 2. Run the Container

#### Custom Input/Output

To process your own files, mount your input/output directories:

```sh
docker run --rm \
  -e UMLS_API_KEY=your_umls_api_key \
  -v /path/to/your/input.txt:/input/input.txt \
  -v /path/to/output_dir:/output \
  ctakes-docker
```

---

## How It Works

- The Dockerfile installs cTAKES and ctakes-resources.
- The entrypoint runs the cTAKES PiperFileRunner with:
  - **Piper file:** DefaultFastPipeline.piper you can customize accordingly
  - **Input:** `/input/input.txt`
  - **Output:** `/output` (XMI format)
  - **UMLS API Key:** Passed via environment variable

You can change the pipeline or input/output by overriding the environment variables:
- `PIPER_FILE_PATH`
- `INPUT_FILE_PATH`
- `OUTPUT_FILE_DIR`

---

## Environment Variables

- `UMLS_API_KEY` (optional): UMLS API key for dictionary lookup
- `PIPER_FILE_PATH`: Path to the Piper file (default: DefaultFastPipeline.piper)
- `INPUT_FILE_PATH`: Path to the input file (default: /input/input.txt)
- `OUTPUT_FILE_DIR`: Output directory (default: /output)

---

## Example Output

After running, the processed XMI file will be available in the `/output` directory.

---

## References

- [Apache cTAKES Documentation](https://ctakes.apache.org/)
- [cTAKES GitHub Releases](https://github.com/apache/ctakes/releases)


