import os
import argparse
from huggingface_hub import HfApi

def get_args():
    parser = argparse.ArgumentParser(description="Upload local directory to Hugging Face Hub.")
    parser.add_argument("--source_dir", type=str, required=True, help="Path to the source directory to upload.")
    parser.add_argument("--repo_id", type=str, required=True, help="Repository ID on Hugging Face Hub (e.g., username/repo_name).")
    parser.add_argument("--huggingface_token", type=str, required=True, help="Hugging Face token.")
    return parser.parse_args()

def upload_directory(api, source_dir, repo_id, token):
    # Walk through the directory and upload each file
    for root, _, files in os.walk(source_dir):
        for file in files:
            file_path = os.path.join(root, file)
            relative_path = os.path.relpath(file_path, source_dir)
            print(f"Uploading {file_path} to {repo_id} at {relative_path}...")
            api.upload_file(
                path_or_fileobj=file_path,
                path_in_repo=relative_path,
                repo_id=repo_id,
                use_auth_token=token
            )

def main():
    args = get_args()
    api = HfApi()

    # Vérifiez que le répertoire source existe
    if not os.path.exists(args.source_dir):
        raise ValueError(f"Le répertoire source n'existe pas : {args.source_dir}")

    # Upload the directory
    upload_directory(api, args.source_dir, args.repo_id, args.huggingface_token)
    print(f"Les fichiers du répertoire {args.source_dir} ont été uploadés vers le dépôt {args.repo_id} sur Hugging Face Hub.")

if __name__ == "__main__":
    main()
