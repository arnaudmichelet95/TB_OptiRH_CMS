import pandas as pd

def extract_sample(input_file_path, output_file_path, sample_size=50):
    # Load the CSV file
    df = pd.read_csv(input_file_path)
    
    # Check if the dataframe has at least 'sample_size' entries
    if len(df) < sample_size:
        raise ValueError(f"The input file must contain at least {sample_size} entries.")
    
    # Select a random sample of entries
    sampled_df = df.sample(n=sample_size, random_state=1)
    
    # Save the sampled entries to a new CSV file
    sampled_df.to_csv(output_file_path, index=False)
    print(f"Sample of {sample_size} entries saved to {output_file_path}")

# Example usage
input_file = 'C:/PERSO/TB/test_files/train_samples_complete.csv'
output_file = 'C:/PERSO/TB/test_files/train_samples.csv'
extract_sample(input_file, output_file)
