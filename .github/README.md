# GitHub Actions Workflows

Этот проект использует GitHub Actions для автоматизации CI/CD процессов.

## Доступные Workflows

### 1. CI (Continuous Integration)
**Файл:** `.github/workflows/ci.yml`

**Триггеры:**
- Push в ветки: `main`, `master`, `develop`
- Pull Request в эти ветки

**Что делает:**
- Запускает тесты на нескольких версиях macOS и Swift
- Проверяет компиляцию проекта
- Проверяет код на наличие предупреждений (warnings)

**Матрица тестирования:**
- macOS 14 (Sonoma) + Swift 5.10 (Xcode 15.4)
- macOS 14 (Sonoma) + Swift 6.0 (Xcode 16.0)
- macOS 15 (Sequoia) + Swift 6.0 (latest Xcode)

**Статус:** Запускается автоматически при каждом push/PR

---

### 2. Release (Автоматические релизы)
**Файл:** `.github/workflows/release.yml`

**Триггер:**
- Создание тега с версией (например: `1.0.0`, `2.1.3`, `1.0.0-beta`)

**Что делает:**
1. Запускает все тесты перед созданием релиза
2. Извлекает changelog для версии из `CHANGELOG.md`
3. Создает GitHub Release с описанием изменений
4. Автоматически помечает pre-release (если версия содержит дефис)

**Как создать релиз:**

```bash
# 1. Обновите CHANGELOG.md
# 2. Создайте и отправьте тег
git tag 1.0.0
git push origin 1.0.0

# Для pre-release версий
git tag 1.0.0-beta.1
git push origin 1.0.0-beta.1
```

**Статус:** Запускается при создании тега версии

---

### 3. Documentation (Генерация документации)
**Файл:** `.github/workflows/docs.yml`

**Триггеры:**
- Push в ветки `main` или `master` (только если изменились файлы в `Sources/`, `Package.swift` или сам workflow)
- Ручной запуск через GitHub UI

**Что делает:**
1. Генерирует документацию с помощью Swift DocC
2. Публикует документацию на GitHub Pages

**Требования для первого запуска:**
1. Включите GitHub Pages в настройках репозитория:
   - Settings → Pages
   - Source: "GitHub Actions"

**URL документации:**
После первого запуска документация будет доступна по адресу:
```
https://yourusername.github.io/VaporAuth/
```

**Ручной запуск:**
- Перейдите в Actions → Documentation → Run workflow

**Статус:** Запускается при изменениях в исходниках на main/master

---

## Настройка после форка/клонирования

### Шаг 1: Включите GitHub Pages
1. Перейдите в **Settings** → **Pages**
2. В разделе **Source** выберите **GitHub Actions**
3. Сохраните изменения

### Шаг 2: Проверьте Permissions
1. Перейдите в **Settings** → **Actions** → **General**
2. В разделе **Workflow permissions** выберите:
   - ✅ Read and write permissions
   - ✅ Allow GitHub Actions to create and approve pull requests
3. Сохраните изменения

### Шаг 3: Обновите URL документации (опционально)
В файле `.github/workflows/docs.yml` замените `--hosting-base-path VaporAuth` на название вашего репозитория.

### Шаг 4: Обновите CHANGELOG.md
В файле `CHANGELOG.md` замените `yourusername` на ваше имя пользователя GitHub.

---

## Badges для README

Добавьте эти badges в основной README.md:

```markdown
[![CI](https://github.com/yourusername/VaporAuth/actions/workflows/ci.yml/badge.svg)](https://github.com/yourusername/VaporAuth/actions/workflows/ci.yml)
[![Documentation](https://github.com/yourusername/VaporAuth/actions/workflows/docs.yml/badge.svg)](https://github.com/yourusername/VaporAuth/actions/workflows/docs.yml)
[![Release](https://github.com/yourusername/VaporAuth/actions/workflows/release.yml/badge.svg)](https://github.com/yourusername/VaporAuth/actions/workflows/release.yml)
```

Замените `yourusername` на ваше имя пользователя GitHub.

---

## Часто задаваемые вопросы

### Как пропустить CI при commit?
Добавьте `[skip ci]` в сообщение коммита:
```bash
git commit -m "docs: update README [skip ci]"
```

### Как запустить workflow вручную?
1. Перейдите в **Actions**
2. Выберите нужный workflow
3. Нажмите **Run workflow**

### Как изменить версии Swift/macOS для тестирования?
Отредактируйте matrix в файле `.github/workflows/ci.yml`:
```yaml
matrix:
  os: [macos-14, macos-15]
  swift: ["6.0"]
```

### Что делать если тесты падают?
1. Проверьте логи в разделе **Actions**
2. Воспроизведите ошибку локально
3. Исправьте и отправьте новый commit

### Как отключить какой-то workflow?
1. Перейдите в **Actions**
2. Выберите workflow
3. Нажмите на три точки → **Disable workflow**

---

## Полезные ссылки

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Swift on GitHub Actions](https://github.com/swift-actions)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Swift DocC Documentation](https://www.swift.org/documentation/docc/)
