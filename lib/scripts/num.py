import json

def remove_entries_with_missing_lyrics(input_file, output_file):
    # Carregar o JSON do arquivo
    with open(input_file, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    # Filtrar os objetos que têm "Letra não encontrada" no campo "lyrics"
    filtered_data = [entry for entry in data if entry.get('lyrics') != "Letra não encontrada"]

    # Salvar o JSON filtrado em um novo arquivo
    with open(output_file, 'w', encoding='utf-8') as file:
        json.dump(filtered_data, file, indent=4, ensure_ascii=False)
    
    print(f"Arquivo filtrado salvo em {output_file}")

# Exemplo de uso
input_file = 'louvoresCOL.json'  # Arquivo JSON com os dados originais
output_file = 'louvores_filtered.json'  # Arquivo para salvar os dados filtrados

remove_entries_with_missing_lyrics(input_file, output_file)
