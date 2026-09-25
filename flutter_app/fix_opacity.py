import os
import re

def replace_with_values(root_dir):
    pattern = re.compile(r'\.withValues\(alpha:\s*([^)]+)\)')
    for subdir, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(subdir, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                new_content = pattern.sub(r'.withOpacity(\1)', content)
                
                if new_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"Updated: {filepath}")

if __name__ == "__main__":
    replace_with_values('c:/bmw_ecommerce/flutter_app/lib')
