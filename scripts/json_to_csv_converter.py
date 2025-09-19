#!/usr/bin/env python3
import json
import pandas as pd
import sys
import os

def convert_trivy_json_to_csv(json_file):
    """Convert Trivy JSON output to CSV format"""
    
    with open(json_file, 'r') as f:
        data = json.load(f)
    
    vulnerabilities = []
    
    # Extract vulnerabilities from Trivy JSON structure
    if 'Results' in data:
        for result in data['Results']:
            target = result.get('Target', 'Unknown')
            if 'Vulnerabilities' in result:
                for vuln in result['Vulnerabilities']:
                    vulnerabilities.append({
                        'Target': target,
                        'VulnerabilityID': vuln.get('VulnerabilityID', ''),
                        'PkgName': vuln.get('PkgName', ''),
                        'InstalledVersion': vuln.get('InstalledVersion', ''),
                        'FixedVersion': vuln.get('FixedVersion', ''),
                        'Severity': vuln.get('Severity', ''),
                        'Title': vuln.get('Title', ''),
                        'Description': vuln.get('Description', '')[:200] + '...' if vuln.get('Description', '') else '',
                        'References': ', '.join(vuln.get('References', [])),
                        'PrimaryURL': vuln.get('PrimaryURL', ''),
                        'CVSS': str(vuln.get('CVSS', {}))
                    })
    
    if not vulnerabilities:
        print(f"No vulnerabilities found in {json_file}")
        return None
    
    # Create DataFrame and save as CSV
    df = pd.DataFrame(vulnerabilities)
    csv_file = json_file.replace('.json', '.csv')
    df.to_csv(csv_file, index=False)
    
    print(f"✅ Converted: {json_file} -> {csv_file}")
    print(f"   Found {len(vulnerabilities)} vulnerabilities")
    
    return csv_file

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 json_to_csv_converter.py <json_file_or_directory>")
        sys.exit(1)
    
    path = sys.argv[1]
    
    if os.path.isfile(path) and path.endswith('.json'):
        convert_trivy_json_to_csv(path)
    elif os.path.isdir(path):
        json_files = [f for f in os.listdir(path) if f.endswith('.json')]
        if not json_files:
            print(f"No JSON files found in {path}")
            sys.exit(1)
        
        print(f"Converting {len(json_files)} JSON files to CSV...")
        for json_file in json_files:
            convert_trivy_json_to_csv(os.path.join(path, json_file))
    else:
        print("Please provide a valid JSON file or directory containing JSON files")
        sys.exit(1)
