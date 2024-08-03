import json

def add_category_to_louvores(file_path, category):
    # Leia o conteúdo do arquivo JSON
    with open(file_path, 'r', encoding='utf-8') as file:
        louvores = json.load(file)
    
    # Adicione a categoria a todos os louvores
    for louvor in louvores:
        louvor['category'] = category
    
    # Escreva o JSON atualizado de volta para o arquivo
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(louvores, file, ensure_ascii=False, indent=4)
    
    print(f'Categoria "{category}" adicionada a todos os louvores.')

if __name__ == "__main__":
    file_path = 'louvores.json'  # Caminho para o seu arquivo JSON
    category = 'Avulsos'         # Categoria a ser adicionada
    add_category_to_louvores(file_path, category)
