import fitz  # PyMuPDF
import re
import json

def extract_text_from_pdf(pdf_path):
    doc = fitz.open(pdf_path)
    text = ""
    for page in doc:
        text += page.get_text("text")
    return text

def split_columns(text):
    lines = text.split('\n')
    left_column = []
    right_column = []
    for line in lines:
        # Supondo que cada linha de texto tenha duas colunas separadas por um espaço grande
        parts = re.split(r'\s{4,}', line)
        if len(parts) == 2:
            left_column.append(parts[0].strip())
            right_column.append(parts[1].strip())
        else:
            left_column.append(line.strip())
    return "\n".join(left_column), "\n".join(right_column)

def organize_louvores(text):
    louvores = re.split(r'\d+ - ', text)[1:]  # Ignora o primeiro split vazio
    louvores_dict = []
    for louvor in louvores:
        parts = louvor.split('\n', 1)  # Divide o título do restante do texto
        title = parts[0].strip()
        lyrics = parts[1].strip() if len(parts) > 1 else ""
        louvores_dict.append({
            "title": title,
            "lyrics": lyrics,
            "category": "Coletânea"
        })
    return louvores_dict

def save_to_json(data, json_path):
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

pdf_path = '001 Coletanea Cifrada Nivel 2 2018.pdf'  # Caminho para o arquivo PDF
json_path = 'coletanea.json'  # Caminho para o arquivo JSON

text = extract_text_from_pdf(pdf_path)
left_column, right_column = split_columns(text)
louvores_left = organize_louvores(left_column)
louvores_right = organize_louvores(right_column)
louvores = louvores_left + louvores_right
save_to_json(louvores, json_path)

print(f"Louvores extraídos e salvos em {json_path}")
