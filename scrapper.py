import requests
from bs4 import BeautifulSoup

import json


url = "https://shopify.dev/docs/storefronts/themes/architecture/settings/input-settings"

req = requests.get(url)

html = BeautifulSoup(req.text, "html.parser")

sections = html.find_all("section", class_="feedback-section")

itype_sections = []

for section in sections[:-1]:
    if section.find("div", class_="react-code-block"):
        code_unformatted = section.find("div", class_="react-code-block").find(
            "script", type="text/plain"
        )

        code_stringified = code_unformatted.get_text()
        title = section.find("h2").get_text()

        description = section.find("p").get_text()

        itype_sections.append(
            {
                "value": section.find("h2").get_text(),
                "documentation": "%s\n ```json\n %s \n```"
                % (description, code_stringified),
            }
        )

with open("./shopify-input-values.json", "w") as f:
    f.write(json.dumps(itype_sections))
