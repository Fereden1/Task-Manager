# Таблица user_data

## До:
``` 
CREATE TABLE user_data (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);
```

## Нарушение:
Таблица находилась только в 1НФ. Атрибут password хранился небезопасно. При добавлении ролей (например, admin, user) возникла бы транзитивная зависимость, т.к. роль зависит от пользователя, а не от первичного ключа напрямую.

## Решение:
Вынести роли в отдельную таблицу user_role, переименовать password в password_hash, добавить дату регистрации.

## После:
```
CREATE TABLE user_role (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE user_data (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT REFERENCES user_role(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
## Нормальная форма:
3НФ / НФБК — все неключевые атрибуты зависят только от первичного ключа.






# Таблица user_profile

## До:
```
CREATE TABLE user_profile (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES user_data(id) ON DELETE CASCADE,
    full_name VARCHAR(100),
    bio TEXT
);
```

## Нарушение:
Формально во 2НФ, но имеется избыточность ключей (id и user_id). Нарушение 3НФ - атрибуты full_name и bio зависят от user_id, а не от первичного ключа id. Потенциальные аномалии обновления
Решение:
Убрать поле id, сделать user_id первичным ключом.

## После:
```
CREATE TABLE user_profile (
    user_id INT PRIMARY KEY REFERENCES user_data(id) ON DELETE CASCADE,
    full_name VARCHAR(100),
    bio TEXT
);
```
## Нормальная форма:
3НФ — все атрибуты зависят только от user_id.







# Таблица category

## До:
```
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);
```
Нарушение: Таблица была в 2НФ, но могла иметь дубликаты категорий ("Работа" и "работа"), что создавало аномалии вставки и обновления.

## Решение:
Добавлено ограничение UNIQUE к полю title

## После:
```
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL
);
```
## Нормальная форма:
3НФ (исключены дубликаты категорий).




# Таблица attachment

## До:
```
CREATE TABLE attachment (
    id SERIAL PRIMARY KEY,
    task_id INT REFERENCES task(id) ON DELETE CASCADE,
    file_path VARCHAR(255) NOT NULL
);
```

## Нарушение:
Во 2НФ, но file_path зависел не только от задачи, а и от загружающего пользователя.
Это вызывало аномалии удаления и обновления.

## Решение:
Добавить uploader_id и uploaded_at.

## После:
```
CREATE TABLE attachment (
    id SERIAL PRIMARY KEY,
    task_id INT REFERENCES task(id) ON DELETE CASCADE,
    uploader_id INT REFERENCES user_data(id) ON DELETE SET NULL,
    file_path VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
## Нормальная форма:
3НФ — каждая зависимость прямая от первичного ключа.








