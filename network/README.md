# Network Laboratory Ansible Role

## Описание
Ansible роль для автоматической настройки сетевой лаборатории согласно заданию курса "Администратор Linux. Professional"

## Структура сети
- **inetRouter** - основной шлюз с NAT
- **centralRouter** - маршрутизатор центрального офиса
- **office1Router** - маршрутизатор офиса 1
- **office2Router** - маршрутизатор офиса 2
- **centralServer** - сервер центрального офиса
- **office1Server** - сервер офиса 1
- **office2Server** - сервер офиса 2

## Использование

### Подготовка
1. Разверните Vagrant стенд из репозитория
2. Скопируйте роль в каталог `ansible/roles/network-lab`
3. Создайте playbook `ansible/provision.yml`:

```yaml
---
- hosts: all
  become: true
  roles:
    - network-lab