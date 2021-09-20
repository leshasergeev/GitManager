# GitManager

Клиент для GitHub.
Позволяет искать репозитории по GitHub через GitHub API.

Как говортся: - `"Не UI'ем единым! 😃"`

## Архитектура
_MVP_ + _Coordinator_

## Patterns
1. Стратегия
2. DI
3. Factory
4. Observer
5. Singleton

## Features
1. Реализована возможность входа в приложение через _OAuth 2.0_ при помощи access token. Вход через WebView.
2. Сохранение полученного токена в Keychain.
3. Ипользование токена при запросах к API.
4. Использование написанного аналога KingFisher - _RemoteImage_, для получения изображений из сети. Подключен локально через CocoaPods.
5. Pagination
6. Во время разработки использовались _Feature Toggles_(aka Feature Flags). Static Flags. 
7. Высокое покрытие тестами.
8. Полная локализация (Русский/English)

## UI
![1. Welcome](https://github.com/iBamboola/GitManager/blob/master/Images/authView.png)
![2. Authorization](https://github.com/iBamboola/GitManager/blob/master/Images/webView.png)
![3. New Search](https://github.com/iBamboola/GitManager/blob/master/Images/placeholder.png)
![4. Searched Data](https://github.com/iBamboola/GitManager/blob/master/Images/searching.png)
![5. User Profile](https://github.com/iBamboola/GitManager/blob/master/Images/profile.png)
