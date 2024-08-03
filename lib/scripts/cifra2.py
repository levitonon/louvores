import requests
from bs4 import BeautifulSoup
import re
import json
import time

def get_headers():
    return {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }

def search_song_url_google(query, max_retries=3):
    search_url = f"https://www.google.com/search?q={query}"
    headers = get_headers()
    
    retries = 0
    while retries < max_retries:
        try:
            response = requests.get(search_url, headers=headers)
            response.raise_for_status()
            soup = BeautifulSoup(response.text, 'html.parser')
            links = soup.find_all('a')
            
            for link in links:
                href = link.get('href')
                if href and 'cifraclub.com.br' in href:
                    match = re.search(r'https://www\.cifraclub\.com\.br[^&]+', href)
                    if match:
                        cifra_link = match.group(0)
                        return cifra_link

            print("Nenhum link do Cifra Club encontrado.")
            return None
        
        except requests.exceptions.HTTPError as err:
            if response.status_code == 429:
                print(f"Erro 429: Muitas requisições. Esperando 60 segundos...")
                time.sleep(60)
                retries += 1
                continue
            print(f"Falha ao acessar o Google. Status code: {response.status_code}")
            return None
        
        except Exception as e:
            print(f"Erro inesperado: {e}")
            return None
    
    print("Número máximo de tentativas atingido.")
    return None

def extract_lyrics(cifra_link, max_retries=3):
    headers = get_headers()
    
    retries = 0
    while retries < max_retries:
        try:
            response = requests.get(cifra_link, headers=headers)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.text, 'html.parser')
            lyrics_div = soup.find('div', class_='cifra')
            
            if lyrics_div:
                full_text = lyrics_div.get_text(separator='\n', strip=True)
                start_index = full_text.lower().find('tom:')
                end_index = full_text.lower().find('repetir')

                if start_index == -1 or end_index == -1:
                    formatted_lyrics = "Letra não encontrada"
                else:
                    lyrics = full_text[start_index:end_index].strip()
                    lyrics = re.sub(r'\b(?:Instrumental:|Modo teatro|Visualização padrão|Fechar Miniplayer|Outros vídeos desta música|Composição de Igreja Cristã Maranata|Colaboração e revisão:|Compartilhar no Facebook|Compartilhar no Twitter|Auto rolagem|Texto|Restaurar|½ Tom|A|Bb|B|C|Db|D|Eb|E|F|F#|G|Ab|Acordes|Afinação|Capotraste|Exibir|cifra em duas colunas|diagramas no corpo da cifra|diagramas no fim da cifra|tablaturas|montagens para canhoto|Adicionar à lista|Metrônomo|Dicionário|Corrigir|Imprimir|Baixar cifra|Cifra Club PRO|0|1|2|3|4|5|6|7|8|9|10|11|12|cancelar|ok|criar|Afinador online)\b', '', lyrics)
                    lyrics = re.sub(r'\n+', '\n', lyrics).strip()

                    lines = lyrics.split('\n')
                    formatted_lines = []
                    chords = []

                    for line in lines:
                        if re.match(r'^[A-G][b#]?$', line.strip()):
                            chords.append(line.strip())
                        else:
                            if chords:
                                formatted_lines.append(' '.join(chords))
                                chords = []
                            formatted_lines.append(line.strip())
                    
                    if chords:
                        formatted_lines.append(' '.join(chords))
                    
                    formatted_lyrics = '\n'.join(formatted_lines)
                    formatted_lyrics = re.sub(r'^\s*Intro:\s*', 'Intro:\n', formatted_lyrics, flags=re.MULTILINE)
                    formatted_lyrics = re.sub(r'^\s*Instrumental:\s*', 'Instrumental:\n', formatted_lyrics, flags=re.MULTILINE)
                    formatted_lyrics = re.sub(r'^\s*Repetir\s*', 'Repetir\n', formatted_lyrics, flags=re.MULTILINE)
            else:
                formatted_lyrics = "Letra não encontrada"
            
            return formatted_lyrics
        
        except requests.exceptions.HTTPError as err:
            if response.status_code == 429:
                print(f"Erro 429: Muitas requisições. Esperando 60 segundos...")
                time.sleep(60)
                retries += 1
                continue
            print(f"Falha ao acessar a página da música. Status code: {response.status_code}")
            return "Letra não encontrada"
        
        except Exception as e:
            print(f"Erro inesperado: {e}")
            return "Letra não encontrada"
    
    print("Número máximo de tentativas atingido.")
    return "Letra não encontrada"

def process_songs(file_path, output_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        songs = file.readlines()
    
    results = []
    not_found = []
    
    for song in songs:
        song = song.strip()
        if not song:
            continue
        
        print(f"\nPesquisando o louvor: {song}")
        start_time = time.time()
        
        song_url = search_song_url_google(song)
        
        if song_url:
            lyrics = extract_lyrics(song_url)
            
            if lyrics != "Letra não encontrada":
                result = {
                    "title": song,
                    "lyrics": lyrics,
                    "category": "Coletânea"
                }
                results.append(result)
            else:
                print(f"Não foi possível extrair a letra para o louvor: {song}")
                not_found.append(song)
        else:
            print(f"Não foi possível encontrar o URL para o louvor: {song}")
            not_found.append(song)
        
        end_time = time.time()
        elapsed_time = end_time - start_time
        print(f"Tempo de pesquisa para o louvor '{song}': {elapsed_time:.2f} segundos")
    
    with open(output_path, 'w', encoding='utf-8') as json_file:
        json.dump(results, json_file, indent=4, ensure_ascii=False)
    
    print(f"\nDados salvos em {output_path}")
    
    if not_found:
        print("\nLouvores não encontrados:")
        for song in not_found:
            print(f"- {song}")

def remove_empty_lyrics(json_file_path):
    with open(json_file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)

    # Remove objetos onde a letra é "Letra não encontrada"
    data = [entry for entry in data if entry.get('lyrics') != "Letra não encontrada"]

    with open(json_file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=4, ensure_ascii=False)

# Exemplo de uso
input_file = 'output.txt'  # Arquivo com a lista de louvores
output_file = 'louvoresCOL.json'  # Arquivo para salvar os resultados

process_songs(input_file, output_file)

# Após o processamento, remova entradas com "Letra não encontrada"
remove_empty_lyrics(output_file)
