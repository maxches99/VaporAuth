# Changelog

Все значимые изменения в этом проекте будут задокументированы в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/),
и этот проект придерживается [Semantic Versioning](https://semver.org/lang/ru/).

## [Unreleased]

### Added
- GitHub Actions workflows для CI/CD
- Автоматическое тестирование на разных версиях Swift/macOS
- Автоматические релизы при создании тегов
- Генерация и публикация документации на GitHub Pages

## [1.0.0-beta] - 2024-01-29

### Added
- VaporAuthCore: базовые протоколы и реализации аутентификации
- VaporAuthOAuth: OAuth 2.0 интеграция с Google
- VaporAuthAdmin: админ функционал и управление ролями
- VaporAuthFields: динамические регистрационные поля
- DefaultUser и DefaultUserToken для быстрого старта
- SimpleAuthController для базовых операций
- SimpleOAuthController для OAuth flow
- Полные рабочие примеры в Examples/
- Документация в README.md и USAGE.md

[Unreleased]: https://github.com/yourusername/VaporAuth/compare/1.0.0-beta...HEAD
[1.0.0-beta]: https://github.com/yourusername/VaporAuth/releases/tag/1.0.0-beta
