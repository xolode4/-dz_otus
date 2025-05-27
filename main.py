import csv
import os
import yaml

# Путь к директории с сервисами
base_dir = 'osh'

# Путь к CSV файлу
csv_file = 'resources.csv'

# Открываем CSV и читаем построчно
with open(csv_file, newline='') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        if len(row) != 2:
            continue  # Пропуск строк с неправильным форматом

        service, cpu_value = row[0].strip(), row[1].strip()
        resource_file = os.path.join(base_dir, service, 'resources.yaml')

        if not os.path.isfile(resource_file):
            print(f"[!] Файл не найден: {resource_file}")
            continue

        # Загружаем YAML-файл
        with open(resource_file) as f:
            try:
                data = yaml.safe_load(f)
            except yaml.YAMLError as e:
                print(f"[!] Ошибка чтения YAML в {resource_file}: {e}")
                continue

        updated = False

        # Обход всех окружений (например, DEV, PROD, TEST)
        for env_key in data:
            env_data = data[env_key]
            if not isinstance(env_data, dict):
                continue

            # Получаем блок ресурсов
            resources = env_data.get('resources', {})
            if not isinstance(resources, dict):
                continue

            # Обрабатываем оба варианта: "requests" и "request"
            for key in ['requests', 'request']:
                req_block = resources.get(key, {})
                if isinstance(req_block, dict) and 'cpu' in req_block:
                    old_value = req_block['cpu']
                    req_block['cpu'] = cpu_value
                    print(f"[+] {resource_file} -> {env_key}: {old_value} → {cpu_value}")
                    updated = True

        # Если были изменения — сохранить файл
        if updated:
            with open(resource_file, 'w') as f:
                yaml.dump(data, f, default_flow_style=False)
        else:
            print(f"[-] Не найдено подходящих записей в {resource_file}")
