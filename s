<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Погода</title>
    <style>
        /* Основные стили */
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: var(--bg-color);
            color: var(--text-color);
            transition: background 0.5s, color 0.5s;
        }

        :root {
            --bg-color: #f0f0f0;
            --text-color: #333;
            --container-bg: rgba(255, 255, 255, 0.9);
        }

        [data-theme="dark"] {
            --bg-color: #1a1a1a;
            --text-color: #f0f0f0;
            --container-bg: rgba(0, 0, 0, 0.7);
        }

        .weather-container {
            background: var(--container-bg);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            text-align: center;
            max-width: 300px;
            width: 100%;
            animation: fadeIn 1s ease-in-out;
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            animation: slideIn 1s ease-in-out;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 10px;
            font-size: 16px;
            background: var(--container-bg);
            color: var(--text-color);
        }

        button {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 10px;
            background: #6a11cb;
            color: #fff;
            cursor: pointer;
            transition: background 0.3s;
        }

        button:hover {
            background: #2575fc;
        }

        .weather-info {
            font-size: 18px;
            animation: fadeIn 2s ease-in-out;
        }

        .weather-icon {
            width: 100px;
            height: 100px;
            margin: 20px 0;
            animation: bounce 2s infinite;
        }

        .temperature {
            font-size: 36px;
            font-weight: bold;
            margin: 10px 0;
        }

        .description {
            font-size: 18px;
            margin: 10px 0;
        }

        .loader {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #6a11cb;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }

        /* Анимации */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body data-theme="light">
    <div class="weather-container">
        <h1>Погода</h1>
        <input type="text" id="cityInput" placeholder="Введите город" value="Москва">
        <button onclick="fetchWeather()">Узнать погоду</button>
        <div class="weather-info" id="weatherInfo">
            <div class="loader" id="loader" style="display: none;"></div>
            <img class="weather-icon" id="weatherIcon" src="" alt="Погода" style="display: none;">
            <div class="temperature" id="temperature"></div>
            <div class="description" id="description"></div>
        </div>
    </div>

    <script>
        const apiKey = 'b9be681c00b4a0d12c86417630b2ebdc'; // Замените на ваш API-ключ OpenWeatherMap

        // Функция для получения погоды
        async function fetchWeather() {
            const city = document.getElementById('cityInput').value;
            if (!city) {
                alert('Введите город');
                return;
            }

            const apiUrl = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric&lang=ru`;

            // Показываем загрузчик
            document.getElementById('loader').style.display = 'block';
            document.getElementById('weatherIcon').style.display = 'none';
            document.getElementById('temperature').textContent = '';
            document.getElementById('description').textContent = '';

            try {
                const response = await fetch(apiUrl);
                const data = await response.json();
                if (data.cod === 200) {
                    const temperature = data.main.temp;
                    const description = data.weather[0].description;
                    const icon = data.weather[0].icon;

                    // Обновляем интерфейс
                    document.getElementById('temperature').textContent = `${temperature}°C`;
                    document.getElementById('description').textContent = description;
                    document.getElementById('weatherIcon').src = `http://openweathermap.org/img/wn/${icon}@2x.png`;
                    document.getElementById('weatherIcon').style.display = 'block';
                } else {
                    alert('Город не найден. Попробуйте еще раз.');
                }
            } catch (error) {
                console.error('Ошибка:', error);
                alert('Ошибка при загрузке данных о погоде.');
            } finally {
                // Скрываем загрузчик
                document.getElementById('loader').style.display = 'none';
            }
        }

        // Инициализация Telegram Web App
        const tg = window.Telegram.WebApp;
        tg.ready(); // Готовим мини-приложение к отображению

        // Автоматическая тема (светлая/темная)
        const prefersDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches;
        document.body.setAttribute('data-theme', prefersDarkMode ? 'dark' : 'light');

        // Загружаем погоду при открытии (по умолчанию для Москвы)
        fetchWeather();
    </script>
</body>
</html>
