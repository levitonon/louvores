from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

# Caminho para o executável do Opera GX
opera_path = r"C:\Users\Levi\AppData\Local\Programs\Opera GX\launcher.exe"  # Ajuste o caminho conforme necessário

# Configurar as opções do Chrome para usar o Opera GX
chrome_options = Options()
chrome_options.binary_location = opera_path

# Configurar o serviço do ChromeDriver
service = Service(executable_path=ChromeDriverManager().install())

# Criar uma instância do WebDriver para o Opera GX usando o ChromeDriver
driver = webdriver.Chrome(service=service, options=chrome_options)

# Seu código para acessar o site vai aqui
driver.get("https://louvando.app/louvores/pBAjLefq5a")

# Faça o que precisa ser feito com o driver, por exemplo, extrair a cifra
