

# Таблица user_profile

До:
```
CREATE TABLE user_profile (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES user_data(id) ON DELETE CASCADE,
    full_name VARCHAR(100),
    bio TEXT
);
```

Нарушение:
2НФ, но имеется избыточность ключей (id и user_id). Нарушение 3НФ - атрибуты full_name и bio зависят от user_id, а не от первичного ключа id. Потенциальные аномалии обновления
Решение:
Убрать поле id, сделать user_id первичным ключом.

После:
```
CREATE TABLE user_profile (
    user_id INT PRIMARY KEY REFERENCES user_data(id) ON DELETE CASCADE,
    full_name VARCHAR(100),
    bio TEXT
);
```
Нормальная форма:
3НФ - все атрибуты зависят только от user_id.







# Таблица category

До:
```
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);
```
Нарушение: Таблица была в 2НФ, но могла иметь дубликаты категорий ("Работа" и "работа"), что создавало аномалии вставки и обновления.

Решение:
Добавлено ограничение UNIQUE к полю title

После:
```
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL
);
```
Нормальная форма:
3НФ (исключены дубликаты категорий).












