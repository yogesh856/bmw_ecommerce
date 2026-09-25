import zipfile
import xml.etree.ElementTree as ET
import os
import shutil
import re

def extract_docx_content(docx_path):
    """Extract text and images from a DOCX file"""
    
    # Create output directory for images
    output_dir = os.path.dirname(docx_path)
    images_dir = os.path.join(output_dir, 'images')
    os.makedirs(images_dir, exist_ok=True)
    
    text_content = []
    images = []
    
    with zipfile.ZipFile(docx_path, 'r') as zip_ref:
        # Extract document.xml for text
        try:
            with zip_ref.open('word/document.xml') as doc_xml:
                tree = ET.parse(doc_xml)
                root = tree.getroot()
                
                # Define namespaces
                namespaces = {
                    'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
                    'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
                }
                
                # Extract all text
                for para in root.iter('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}p'):
                    para_text = ''
                    for text in para.iter('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}t'):
                        if text.text:
                            para_text += text.text
                    if para_text.strip():
                        text_content.append(para_text.strip())
        except Exception as e:
            print(f"Error extracting text: {e}")
        
        # Extract images
        for file_info in zip_ref.namelist():
            if file_info.startswith('word/media/') and any(file_info.lower().endswith(ext) for ext in ['.png', '.jpg', '.jpeg', '.gif', '.bmp']):
                # Extract image
                image_name = os.path.basename(file_info)
                image_path = os.path.join(images_dir, image_name)
                with zip_ref.open(file_info) as src, open(image_path, 'wb') as dst:
                    dst.write(src.read())
                images.append(image_name)
                print(f"Extracted image: {image_name}")
    
    return text_content, images

if __name__ == "__main__":
    docx_path = r"c:\Users\Yogesh\Downloads\Feb 2026 current affairs data (1).docx"
    text, images = extract_docx_content(docx_path)
    
    print("\n=== TEXT CONTENT ===\n")
    for i, para in enumerate(text):
        print(f"{i+1}. {para}")
        print("---")
    
    print(f"\n=== IMAGES FOUND: {len(images)} ===")
    for img in images:
        print(img)
