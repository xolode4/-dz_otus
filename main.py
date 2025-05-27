import csv
import os
import yaml

# Путь к директории с сервисами
base_dir = 'osh'

# Путь к CSV файлу
csv_file = 'resources.csv'

# Чтение CSV
with open(csv_file, newline='') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        if len(row) != 2:
            continue  # Пропустить строки с неверным количеством столбцов

        service, cpu_value = row[0].strip(), row[1].strip()
        resource_file = os.path.join(base_dir, service, 'resources.yaml')

        if not os.path.isfile(resource_file):
            print(f"[!] Файл не найден: {resource_file}")
            continue

        with open(resource_file) as f:
            try:
                data = yaml.safe_load(f)
            except yaml.YAMLError as e:
                print(f"[!] Ошибка чтения YAML в {resource_file}: {e}")
                continue

        updated = False
        for env in data:
            try:
                if (
                    isinstance(data[env], dict)
                    and 'resources' in data[env]
                    and 'request' in data[env]['resources']
                ):
                    data[env]['resources']['request']['cpu'] = cpu_value
                    updated = True
            except Exception as e:
                print(f"[!] Ошибка при обновлении {env} в {resource_file}: {e}")

        if updated:
            with open(resource_file, 'w') as f:
                yaml.dump(data, f, default_flow_style=False)
            print(f"[+] Обновлено: {resource_file} -> cpu: {cpu_value}")
        else:
            print(f"[-] Не найдено подходящих разделов в {resource_file}")
