import Foundation
import Recipe

// swiftlint:disable line_length
let sampleRecipes: [Recipe] = [

    // MARK: - 1. Паста Карбонара

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Espaguetis_carbonara.jpg/960px-Espaguetis_carbonara.jpg")!,
        cookingTimeMins: 30,
        complexity: 2,
        title: "Паста Карбонара",
        description: "Классическое римское блюдо: спагетти с кремовым соусом из яиц, сыра пекорино и хрустящего гуанчале.",
        ingredients: [
            Ingredient(name: "Спагетти — 400 г"),
            Ingredient(name: "Гуанчале или бекон — 150 г"),
            Ingredient(name: "Яичные желтки — 4 шт."),
            Ingredient(name: "Сыр пекорино романо — 100 г"),
            Ingredient(name: "Чёрный молотый перец — по вкусу"),
            Ingredient(name: "Соль — по вкусу"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Варим пасту", imageSource: nil,
                       text: "Доводим большую кастрюлю воды до кипения, хорошо солим. Отвариваем спагетти до состояния al dente, оставляем один стакан воды от варки."),
            RecipeStep(id: UUID(), title: "Обжариваем гуанчале", imageSource: nil,
                       text: "Нарезаем гуанчале небольшими кубиками и обжариваем на сухой сковороде на среднем огне около 5–7 минут до золотистой корочки. Снимаем с огня."),
            RecipeStep(id: UUID(), title: "Готовим соус", imageSource: nil,
                       text: "В миске взбиваем желтки с половиной тёртого пекорино и щедрой порцией чёрного перца. Постепенно добавляем 2–3 ложки воды от пасты, чтобы соус стал жидким."),
            RecipeStep(id: UUID(), title: "Соединяем", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Espaguetis_carbonara.jpg/960px-Espaguetis_carbonara.jpg")!,
                       text: "Горячую пасту перекладываем к гуанчале, снимаем сковороду с огня и вливаем яично-сырный соус, быстро перемешивая. При необходимости добавляем воду от варки для нужной консистенции. Посыпаем оставшимся пекорино и перцем."),
        ],
        bottomText: TextBlock(id: UUID(), text: "Никаких сливок! Кремовость соуса достигается исключительно яйцами, сыром и крахмалистой водой от пасты.", title: "Секрет приготовления")
    ),

    // MARK: - 2. Суши

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Sushi_platter.jpg/960px-Sushi_platter.jpg")!,
        cookingTimeMins: 60,
        complexity: 4,
        title: "Суши",
        description: "Японские суши нигири — рис с уксусной заправкой и ломтиком свежей рыбы или морепродуктов.",
        ingredients: [
            Ingredient(name: "Рис для суши — 300 г"),
            Ingredient(name: "Рисовый уксус — 3 ст. л."),
            Ingredient(name: "Сахар — 1 ст. л."),
            Ingredient(name: "Соль — 1 ч. л."),
            Ingredient(name: "Лосось свежий — 200 г"),
            Ingredient(name: "Тунец свежий — 200 г"),
            Ingredient(name: "Соевый соус — для подачи"),
            Ingredient(name: "Васаби — по вкусу"),
            Ingredient(name: "Маринованный имбирь — для подачи"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Варим рис", imageSource: nil,
                       text: "Промываем рис несколько раз до прозрачной воды. Варим в соотношении 1:1,2 с водой. Смешиваем уксус, сахар и соль, нагреваем до растворения. Заправляем тёплый рис и аккуратно перемешиваем деревянной лопаткой."),
            RecipeStep(id: UUID(), title: "Разделываем рыбу", imageSource: nil,
                       text: "Острым ножом нарезаем охлаждённую рыбу поперёк волокон ломтями толщиной около 5 мм под небольшим углом. Держим рыбу холодной до сборки."),
            RecipeStep(id: UUID(), title: "Формируем нигири", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Sushi_platter.jpg/960px-Sushi_platter.jpg")!,
                       text: "Смачиваем руки водой с каплей уксуса. Берём около 20 г риса, формируем продолговатый комочек. Чуть смазываем ломтик рыбы васаби с внутренней стороны, кладём поверх рисового комочка и слегка прижимаем."),
            RecipeStep(id: UUID(), title: "Подача", imageSource: nil,
                       text: "Выкладываем суши на деревянную дощечку. Подаём с соевым соусом, имбирём и васаби. Суши лучше есть сразу после приготовления, не позволяя рису остывать в холодильнике."),
        ],
        bottomText: nil
    ),

    // MARK: - 3. Тако

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/001_Tacos_de_carnitas%2C_carne_asada_y_al_pastor.jpg/960px-001_Tacos_de_carnitas%2C_carne_asada_y_al_pastor.jpg")!,
        cookingTimeMins: 35,
        complexity: 2,
        title: "Тако с говядиной",
        description: "Мексиканские тако с сочной говядиной, сальсой, авокадо и хрустящей начинкой в кукурузных лепёшках.",
        ingredients: [
            Ingredient(name: "Говяжий фарш — 500 г"),
            Ingredient(name: "Кукурузные лепёшки — 8 шт."),
            Ingredient(name: "Лук — 1 шт."),
            Ingredient(name: "Чеснок — 3 зубчика"),
            Ingredient(name: "Помидоры — 2 шт."),
            Ingredient(name: "Авокадо — 1 шт."),
            Ingredient(name: "Кинза — небольшой пучок"),
            Ingredient(name: "Лайм — 1 шт."),
            Ingredient(name: "Тмин — 1 ч. л."),
            Ingredient(name: "Перец чили — 1 ч. л."),
            Ingredient(name: "Соль, перец — по вкусу"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Обжариваем мясо", imageSource: nil,
                       text: "Мелко нарезаем лук и чеснок. Обжариваем лук на масле до мягкости, добавляем чеснок, затем фарш. Разбиваем фарш лопаткой, жарим до готовности. Приправляем тмином, перцем чили, солью и чёрным перцем."),
            RecipeStep(id: UUID(), title: "Делаем сальсу", imageSource: nil,
                       text: "Мелко нарезаем помидоры, кинзу. Смешиваем с соком половины лайма и щепоткой соли. Оставляем на 10 минут, чтобы вкусы смешались."),
            RecipeStep(id: UUID(), title: "Прогреваем лепёшки", imageSource: nil,
                       text: "Разогреваем лепёшки по 30 секунд с каждой стороны на сухой сковороде или прямо над огнём газовой плиты. Заворачиваем в фольгу, чтобы не остыли."),
            RecipeStep(id: UUID(), title: "Собираем тако", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/001_Tacos_de_carnitas%2C_carne_asada_y_al_pastor.jpg/960px-001_Tacos_de_carnitas%2C_carne_asada_y_al_pastor.jpg")!,
                       text: "На каждую лепёшку кладём мясо, сверху — сальсу и ломтики авокадо. Сбрызгиваем соком лайма и украшаем листьями кинзы. Подаём немедленно."),
        ],
        bottomText: nil
    ),

    // MARK: - 4. Круассаны

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Croissant-Petr_Kratochvil.jpg/960px-Croissant-Petr_Kratochvil.jpg")!,
        cookingTimeMins: 180,
        complexity: 5,
        title: "Французские круассаны",
        description: "Слоёная венская выпечка с хрустящей золотистой корочкой и нежной маслянистой серединой.",
        ingredients: [
            Ingredient(name: "Мука — 500 г"),
            Ingredient(name: "Молоко — 300 мл"),
            Ingredient(name: "Масло сливочное (в тесто) — 50 г"),
            Ingredient(name: "Масло сливочное (для слоения) — 250 г"),
            Ingredient(name: "Дрожжи сухие — 7 г"),
            Ingredient(name: "Сахар — 60 г"),
            Ingredient(name: "Соль — 10 г"),
            Ingredient(name: "Яйцо — 1 шт. для смазки"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Замешиваем тесто", imageSource: nil,
                       text: "Смешиваем муку, дрожжи, сахар и соль. Добавляем тёплое молоко и растопленное масло, замешиваем гладкое тесто. Заворачиваем в плёнку и убираем в холодильник на ночь."),
            RecipeStep(id: UUID(), title: "Подготавливаем масло", imageSource: nil,
                       text: "Холодное масло для слоения раскатываем между листами бумаги в прямоугольник 20×20 см. Убираем в холодильник на 30 минут."),
            RecipeStep(id: UUID(), title: "Слоим тесто", imageSource: nil,
                       text: "Раскатываем тесто в прямоугольник вдвое шире масляного пласта. Кладём масло на центр, складываем тесто конвертом. Раскатываем, складываем втрое — это один тур. Повторяем 3 раза, убирая в холодильник между турами на 30 минут."),
            RecipeStep(id: UUID(), title: "Формируем и выпекаем", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Croissant-Petr_Kratochvil.jpg/960px-Croissant-Petr_Kratochvil.jpg")!,
                       text: "Раскатываем тесто в тонкий пласт, нарезаем длинные треугольники. Сворачиваем каждый от основания к вершине. Оставляем расстояться 2 часа. Смазываем яйцом и выпекаем 18–20 минут при 200 °C до золотистого цвета."),
        ],
        bottomText: TextBlock(id: UUID(), text: "Всё масло должно быть одинаковой температуры с тестом — холодным, но пластичным. Тёплое масло потечёт и испортит слоистость.", title: "Ключевой момент")
    ),

    // MARK: - 5. Паэлья

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/01_Paella_Valenciana_original.jpg/960px-01_Paella_Valenciana_original.jpg")!,
        cookingTimeMins: 60,
        complexity: 3,
        title: "Паэлья Валенсьяна",
        description: "Традиционное испанское блюдо из риса с шафраном, курицей, кроликом и свежими овощами.",
        ingredients: [
            Ingredient(name: "Рис арборио или бомба — 300 г"),
            Ingredient(name: "Куриные бёдра — 4 шт."),
            Ingredient(name: "Кролик (порционные куски) — 400 г"),
            Ingredient(name: "Зелёная фасоль — 150 г"),
            Ingredient(name: "Помидоры — 2 шт."),
            Ingredient(name: "Паприка — 1 ч. л."),
            Ingredient(name: "Шафран — щепотка"),
            Ingredient(name: "Бульон куриный — 900 мл"),
            Ingredient(name: "Оливковое масло — 3 ст. л."),
            Ingredient(name: "Соль — по вкусу"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Обжариваем мясо", imageSource: nil,
                       text: "Разогреваем масло в широкой сковороде (паэльере). Обжариваем курицу и кролика на сильном огне до золотистой корочки со всех сторон, около 10 минут. Отодвигаем к краям."),
            RecipeStep(id: UUID(), title: "Готовим основу", imageSource: nil,
                       text: "В центр сковороды кладём натёртые помидоры, обжариваем 5 минут. Добавляем паприку, перемешиваем с мясом. Вливаем горячий бульон с шафраном, доводим до кипения."),
            RecipeStep(id: UUID(), title: "Добавляем рис", imageSource: nil,
                       text: "Рассыпаем рис равномерно по сковороде, не перемешивая. Раскладываем зелёную фасоль. Готовим на среднем огне 10 минут без помешивания."),
            RecipeStep(id: UUID(), title: "Формируем корочку", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/01_Paella_Valenciana_original.jpg/960px-01_Paella_Valenciana_original.jpg")!,
                       text: "Уменьшаем огонь и готовим ещё 8–10 минут. В конце на 1–2 минуты увеличиваем огонь для образования корочки (socarrat) на дне. Накрываем фольгой и оставляем на 5 минут."),
        ],
        bottomText: nil
    ),

    // MARK: - 6. Баттер чикен

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg/960px-Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg")!,
        cookingTimeMins: 50,
        complexity: 3,
        title: "Баттер Чикен",
        description: "Сочная курица в нежном томатно-сливочном соусе с ароматными индийскими специями. Подаётся с наном или рисом.",
        ingredients: [
            Ingredient(name: "Куриное филе — 700 г"),
            Ingredient(name: "Йогурт — 150 мл"),
            Ingredient(name: "Лимонный сок — 2 ст. л."),
            Ingredient(name: "Гарам масала — 2 ч. л."),
            Ingredient(name: "Куркума — 1 ч. л."),
            Ingredient(name: "Сливочное масло — 50 г"),
            Ingredient(name: "Лук — 1 шт."),
            Ingredient(name: "Помидоры — 400 г (или консервированные)"),
            Ingredient(name: "Сливки 20% — 150 мл"),
            Ingredient(name: "Кардамон, кориандр, чили — по 0,5 ч. л."),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Маринуем курицу", imageSource: nil,
                       text: "Нарезаем курицу кубиками, смешиваем с йогуртом, лимонным соком, куркумой и 1 ч. л. гарам масалы. Маринуем минимум 30 минут, лучше ночь в холодильнике."),
            RecipeStep(id: UUID(), title: "Обжариваем курицу", imageSource: nil,
                       text: "Разогреваем сковороду с маслом, обжариваем курицу кусочками до появления подрумяненных краёв, 6–8 минут. Откладываем в сторону."),
            RecipeStep(id: UUID(), title: "Варим соус", imageSource: nil,
                       text: "В той же сковороде обжариваем лук до мягкости. Добавляем чеснок, имбирь, оставшиеся специи. Кладём помидоры, тушим 15 минут до загустения. Пюрируем соус погружным блендером."),
            RecipeStep(id: UUID(), title: "Соединяем", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg/960px-Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg")!,
                       text: "Возвращаем курицу в соус, добавляем сливки. Томим на медленном огне 10 минут. Финишируем кусочком сливочного масла для блеска. Подаём с горячим наном или рисом."),
        ],
        bottomText: nil
    ),

    // MARK: - 7. Пад Тай

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Phat_Thai_kung_Chang_Khien_street_stall.jpg/960px-Phat_Thai_kung_Chang_Khien_street_stall.jpg")!,
        cookingTimeMins: 30,
        complexity: 3,
        title: "Пад Тай",
        description: "Культовая тайская лапша с креветками, тофу, яйцом и хрустящим арахисом в кисло-сладком соусе.",
        ingredients: [
            Ingredient(name: "Рисовая лапша — 200 г"),
            Ingredient(name: "Тигровые креветки — 200 г"),
            Ingredient(name: "Тофу — 150 г"),
            Ingredient(name: "Яйца — 2 шт."),
            Ingredient(name: "Соус тамаринд — 3 ст. л."),
            Ingredient(name: "Рыбный соус — 2 ст. л."),
            Ingredient(name: "Сахар пальмовый — 1 ст. л."),
            Ingredient(name: "Зелёный лук — 4 пера"),
            Ingredient(name: "Ростки сои — 100 г"),
            Ingredient(name: "Жареный арахис — 3 ст. л."),
            Ingredient(name: "Лайм — 1 шт."),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Замачиваем лапшу", imageSource: nil,
                       text: "Замачиваем рисовую лапшу в тёплой воде на 20 минут до мягкости, но не до полной готовности. Откидываем на дуршлаг."),
            RecipeStep(id: UUID(), title: "Готовим соус", imageSource: nil,
                       text: "Смешиваем тамариндовый соус, рыбный соус и пальмовый сахар. Прогреваем в небольшом сотейнике до растворения сахара, снимаем с огня."),
            RecipeStep(id: UUID(), title: "Обжариваем на воке", imageSource: nil,
                       text: "Раскаляем вок. Обжариваем тофу до золотистого цвета, добавляем креветки. Отодвигаем к краю, вбиваем яйца и быстро перемешиваем. Кладём лапшу и поливаем соусом."),
            RecipeStep(id: UUID(), title: "Подача", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Phat_Thai_kung_Chang_Khien_street_stall.jpg/960px-Phat_Thai_kung_Chang_Khien_street_stall.jpg")!,
                       text: "Добавляем ростки сои и зелёный лук, перемешиваем 30 секунд. Выкладываем в тарелку, посыпаем дроблёным арахисом, подаём с долькой лайма."),
        ],
        bottomText: nil
    ),

    // MARK: - 8. Утка по-пекински

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/81/Peking_Duck%2C_2014_%2802%29.jpg/960px-Peking_Duck%2C_2014_%2802%29.jpg")!,
        cookingTimeMins: 120,
        complexity: 5,
        title: "Утка по-пекински",
        description: "Парадное китайское блюдо: утка с лакированной хрустящей кожей, завёрнутая в тонкие блинчики с хойсином и огурцом.",
        ingredients: [
            Ingredient(name: "Утка — 2 кг"),
            Ingredient(name: "Соевый соус — 4 ст. л."),
            Ingredient(name: "Рисовое вино — 2 ст. л."),
            Ingredient(name: "Мёд — 3 ст. л."),
            Ingredient(name: "Пятиспецовый порошок — 1 ч. л."),
            Ingredient(name: "Тонкие блинчики (маньтоу) — 16 шт."),
            Ingredient(name: "Соус хойсин — 4 ст. л."),
            Ingredient(name: "Огурец — 1 шт."),
            Ingredient(name: "Зелёный лук — 4 пера"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Подготовка утки", imageSource: nil,
                       text: "Промываем утку, обсушиваем. Кожу намазываем смесью мёда, соевого соуса, вина и пятиспецового порошка. Подвешиваем или кладём на решётку в холодильнике без крышки на 12–24 часа, чтобы кожа подсохла."),
            RecipeStep(id: UUID(), title: "Запекаем", imageSource: nil,
                       text: "Разогреваем духовку до 200 °C. Кладём утку грудкой вниз на решётку над противнем. Через 30 минут переворачиваем и запекаем ещё 40–50 минут. В последние 10 минут смазываем медовой смесью ещё раз."),
            RecipeStep(id: UUID(), title: "Разделываем", imageSource: nil,
                       text: "Даём утке отдохнуть 10 минут. Острым ножом срезаем хрустящую кожу отдельно от мяса и нарезаем квадратами. Мясо также нарезаем тонкими пластами."),
            RecipeStep(id: UUID(), title: "Подача в блинчиках", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/81/Peking_Duck%2C_2014_%2802%29.jpg/960px-Peking_Duck%2C_2014_%2802%29.jpg")!,
                       text: "На прогретый блинчик наносим немного соуса хойсин. Кладём кусочек хрустящей кожи, ломтик мяса, полоску огурца и зелёный лук. Сворачиваем рулетиком и едим руками."),
        ],
        bottomText: TextBlock(id: UUID(), text: "Секрет хрустящей корочки — полное высыхание кожи перед запеканием. Не торопитесь: 24 часа в холодильнике дают лучший результат.", title: "Совет")
    ),

    // MARK: - 9. Шакшука

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Shakshuka_by_Calliopejen1.jpg/960px-Shakshuka_by_Calliopejen1.jpg")!,
        cookingTimeMins: 25,
        complexity: 1,
        title: "Шакшука",
        description: "Ближневосточное блюдо: яйца, поширование прямо в остром томатном соусе со специями. Идеальный завтрак.",
        ingredients: [
            Ingredient(name: "Яйца — 4 шт."),
            Ingredient(name: "Помидоры консервированные — 400 г"),
            Ingredient(name: "Болгарский перец — 1 шт."),
            Ingredient(name: "Лук — 1 шт."),
            Ingredient(name: "Чеснок — 3 зубчика"),
            Ingredient(name: "Паприка — 1 ч. л."),
            Ingredient(name: "Зира — 0.5 ч. л."),
            Ingredient(name: "Перец чили — по вкусу"),
            Ingredient(name: "Оливковое масло — 2 ст. л."),
            Ingredient(name: "Кинза или петрушка — для подачи"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Обжариваем овощи", imageSource: nil,
                       text: "Разогреваем масло в глубокой сковороде. Обжариваем нарезанный лук и перец до мягкости, 5–7 минут. Добавляем чеснок, зиру и паприку, жарим ещё 1 минуту."),
            RecipeStep(id: UUID(), title: "Готовим соус", imageSource: nil,
                       text: "Добавляем помидоры, разминаем их ложкой. Солим, добавляем перец чили по вкусу. Тушим на среднем огне 10 минут до загустения."),
            RecipeStep(id: UUID(), title: "Вводим яйца", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Shakshuka_by_Calliopejen1.jpg/960px-Shakshuka_by_Calliopejen1.jpg")!,
                       text: "Делаем в соусе 4 углубления ложкой, аккуратно вбиваем в каждое по яйцу. Накрываем крышкой и готовим 5–7 минут до желаемой степени готовности белка (желток должен оставаться жидким)."),
            RecipeStep(id: UUID(), title: "Подача", imageSource: nil,
                       text: "Посыпаем свежей кинзой или петрушкой. Подаём прямо в сковороде с хрустящим хлебом или питой для обмакивания в соус."),
        ],
        bottomText: nil
    ),

    // MARK: - 10. Мусака

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/MussakasMeMelitsanesKePatates01.JPG/960px-MussakasMeMelitsanesKePatates01.JPG")!,
        cookingTimeMins: 90,
        complexity: 3,
        title: "Греческая мусака",
        description: "Запеканка из баклажанов, мясного соуса болоньезе и нежного соуса бешамель — классика греческой кухни.",
        ingredients: [
            Ingredient(name: "Баклажаны — 3 шт."),
            Ingredient(name: "Говяжий фарш — 500 г"),
            Ingredient(name: "Лук — 2 шт."),
            Ingredient(name: "Помидоры — 400 г"),
            Ingredient(name: "Красное вино — 100 мл"),
            Ingredient(name: "Корица — 0.5 ч. л."),
            Ingredient(name: "Молоко — 500 мл"),
            Ingredient(name: "Масло сливочное — 50 г"),
            Ingredient(name: "Мука — 3 ст. л."),
            Ingredient(name: "Яйцо — 2 шт."),
            Ingredient(name: "Сыр (пармезан или гравьера) — 100 г"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Готовим баклажаны", imageSource: nil,
                       text: "Нарезаем баклажаны кружками, солим, даём постоять 20 минут. Промываем, обсушиваем. Обжариваем на масле до золотистого цвета с обеих сторон или запекаем при 200 °C 15 минут."),
            RecipeStep(id: UUID(), title: "Готовим мясной соус", imageSource: nil,
                       text: "Обжариваем лук до мягкости, добавляем фарш, жарим до румяной корочки. Вливаем вино, выпариваем. Добавляем помидоры, корицу, соль. Тушим 20 минут до загустения."),
            RecipeStep(id: UUID(), title: "Готовим бешамель", imageSource: nil,
                       text: "В сотейнике растапливаем масло, добавляем муку, помешивая, жарим 1 минуту. Постепенно вливаем тёплое молоко, постоянно помешивая, до густого соуса. Снимаем с огня, вводим яйца и половину сыра."),
            RecipeStep(id: UUID(), title: "Собираем и запекаем", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/MussakasMeMelitsanesKePatates01.JPG/960px-MussakasMeMelitsanesKePatates01.JPG")!,
                       text: "В форму для запекания выкладываем слой баклажанов, затем мясной соус, снова баклажаны. Заливаем бешамелем, посыпаем оставшимся сыром. Запекаем при 180 °C 40–45 минут до золотистой корочки."),
        ],
        bottomText: nil
    ),

    // MARK: - 11. Борщ

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Borscht_served.jpg/960px-Borscht_served.jpg")!,
        cookingTimeMins: 90,
        complexity: 2,
        title: "Украинский борщ",
        description: "Наваристый свекольный суп на говяжьем бульоне с капустой, картофелем и фасолью. Подаётся со сметаной.",
        ingredients: [
            Ingredient(name: "Говядина на косточке — 600 г"),
            Ingredient(name: "Свёкла — 2 шт."),
            Ingredient(name: "Капуста белокочанная — 300 г"),
            Ingredient(name: "Картофель — 3 шт."),
            Ingredient(name: "Морковь — 1 шт."),
            Ingredient(name: "Лук — 1 шт."),
            Ingredient(name: "Помидоры (или томатная паста) — 2 ст. л."),
            Ingredient(name: "Фасоль консервированная — 200 г"),
            Ingredient(name: "Чеснок — 3 зубчика"),
            Ingredient(name: "Сметана — для подачи"),
            Ingredient(name: "Укроп — для подачи"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Варим бульон", imageSource: nil,
                       text: "Заливаем мясо 2 л холодной воды, доводим до кипения. Снимаем пену, добавляем луковицу и морковь целиком, лавровый лист. Варим на медленном огне 1 час до мягкости мяса. Извлекаем мясо и нарезаем."),
            RecipeStep(id: UUID(), title: "Тушим свёклу", imageSource: nil,
                       text: "Трём свёклу на крупной тёрке. Обжариваем с луком и морковью на масле 5 минут. Добавляем томатную пасту, немного уксуса для цвета, тушим ещё 10 минут."),
            RecipeStep(id: UUID(), title: "Добавляем овощи в бульон", imageSource: nil,
                       text: "В кипящий бульон кладём картофель кубиками, через 10 минут — нашинкованную капусту. Когда капуста станет мягкой, добавляем зажарку со свёклой и фасоль."),
            RecipeStep(id: UUID(), title: "Доводим до вкуса", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Borscht_served.jpg/960px-Borscht_served.jpg")!,
                       text: "Возвращаем нарезанное мясо, давим чеснок, солим и перчим. Варим 5 минут. Настаиваем под крышкой 20 минут. Подаём со сметаной, свежим укропом и чёрным хлебом."),
        ],
        bottomText: nil
    ),

    // MARK: - 12. Том Ям

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Tom_yam_kung_maenam.jpg/960px-Tom_yam_kung_maenam.jpg")!,
        cookingTimeMins: 30,
        complexity: 2,
        title: "Том Ям Кунг",
        description: "Острый кислый тайский суп с тигровыми креветками, лемонграссом, кафир-лаймом и кокосовым молоком.",
        ingredients: [
            Ingredient(name: "Тигровые креветки — 300 г"),
            Ingredient(name: "Кокосовое молоко — 400 мл"),
            Ingredient(name: "Куриный бульон — 600 мл"),
            Ingredient(name: "Лемонграсс — 2 стебля"),
            Ingredient(name: "Листья кафир-лайма — 4 шт."),
            Ingredient(name: "Галангал (или имбирь) — 20 г"),
            Ingredient(name: "Грибы шиитаке — 150 г"),
            Ingredient(name: "Рыбный соус — 3 ст. л."),
            Ingredient(name: "Сок лайма — 3 ст. л."),
            Ingredient(name: "Перец чили — 2 шт."),
            Ingredient(name: "Кинза — для подачи"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Готовим ароматическую основу", imageSource: nil,
                       text: "Отбиваем лемонграсс плоской стороной ножа, нарезаем кусками. Галангал нарезаем кружками. Кладём в бульон вместе с листьями кафир-лайма и доводим до кипения. Варим 5 минут, чтобы специи отдали аромат."),
            RecipeStep(id: UUID(), title: "Добавляем грибы", imageSource: nil,
                       text: "Добавляем нарезанные грибы шиитаке в бульон. Вливаем кокосовое молоко. Кладём нарезанный перец чили. Доводим до кипения и варим 3 минуты."),
            RecipeStep(id: UUID(), title: "Добавляем креветки", imageSource: nil,
                       text: "Кладём в суп очищенные креветки. Варим 2–3 минуты до розового цвета. Приправляем рыбным соусом и соком лайма. Пробуем: суп должен быть острым, кислым и солёным одновременно."),
            RecipeStep(id: UUID(), title: "Подача", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Tom_yam_kung_maenam.jpg/960px-Tom_yam_kung_maenam.jpg")!,
                       text: "Разливаем по мискам, украшаем свежей кинзой. Лемонграсс и галангал несъедобны — их отодвигают в сторону. Подаём с отварным жасминовым рисом."),
        ],
        bottomText: nil
    ),

    // MARK: - 13. Тирамису

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Tiramisu_-_Raffaele_Diomede.jpg/960px-Tiramisu_-_Raffaele_Diomede.jpg")!,
        cookingTimeMins: 30,
        complexity: 3,
        title: "Тирамису",
        description: "Итальянский десерт: слои савоярди, пропитанных эспрессо, и крема из маскарпоне с желтками. Посыпается какао.",
        ingredients: [
            Ingredient(name: "Маскарпоне — 500 г"),
            Ingredient(name: "Яичные желтки — 4 шт."),
            Ingredient(name: "Сахар — 100 г"),
            Ingredient(name: "Сливки 33% — 200 мл"),
            Ingredient(name: "Печенье савоярди — 24 шт."),
            Ingredient(name: "Эспрессо (крепкий кофе) — 300 мл"),
            Ingredient(name: "Кофейный ликёр — 2 ст. л. (опционально)"),
            Ingredient(name: "Какао-порошок — для посыпки"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Взбиваем крем", imageSource: nil,
                       text: "Взбиваем желтки с сахаром до густой кремовой массы. Добавляем маскарпоне и аккуратно перемешиваем лопаткой. Отдельно взбиваем сливки до мягких пиков и вмешиваем в крем."),
            RecipeStep(id: UUID(), title: "Готовим кофе", imageSource: nil,
                       text: "Завариваем крепкий эспрессо или кофе, даём остыть до комнатной температуры. При желании добавляем кофейный ликёр."),
            RecipeStep(id: UUID(), title: "Собираем слои", imageSource: nil,
                       text: "Быстро окунаем каждое савоярди в кофе на 1–2 секунды (не дольше!). Укладываем в форму. Покрываем половиной крема. Выкладываем второй слой пропитанного печенья."),
            RecipeStep(id: UUID(), title: "Охлаждаем и подаём", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Tiramisu_-_Raffaele_Diomede.jpg/960px-Tiramisu_-_Raffaele_Diomede.jpg")!,
                       text: "Покрываем оставшимся кремом, разравниваем. Обильно посыпаем какао через сито. Убираем в холодильник минимум на 4 часа, лучше на ночь. Нарезаем и подаём."),
        ],
        bottomText: TextBlock(id: UUID(), text: "Не замачивайте савоярди надолго — 1–2 секунды достаточно. Слишком влажное печенье сделает тирамису водянистым.", title: "Важно")
    ),

    // MARK: - 14. Пицца Маргарита

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Pizza_Margherita_stu_spivack.jpg/960px-Pizza_Margherita_stu_spivack.jpg")!,
        cookingTimeMins: 45,
        complexity: 2,
        title: "Пицца Маргарита",
        description: "Классическая неаполитанская пицца с томатным соусом, моцареллой и свежим базиликом.",
        ingredients: [
            Ingredient(name: "Мука пшеничная 00 — 300 г"),
            Ingredient(name: "Вода тёплая — 190 мл"),
            Ingredient(name: "Дрожжи сухие — 3 г"),
            Ingredient(name: "Соль — 7 г"),
            Ingredient(name: "Оливковое масло — 1 ст. л."),
            Ingredient(name: "Помидоры (пассата) — 150 мл"),
            Ingredient(name: "Моцарелла — 125 г"),
            Ingredient(name: "Базилик свежий — несколько листьев"),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Замешиваем тесто", imageSource: nil,
                       text: "Разводим дрожжи в тёплой воде. Смешиваем с мукой и солью, замешиваем 10 минут до эластичного гладкого теста. Добавляем масло, месим ещё 2 минуты. Оставляем под плёнкой на 1 час для подъёма."),
            RecipeStep(id: UUID(), title: "Готовим соус", imageSource: nil,
                       text: "Пассату приправляем солью, орегано и каплей оливкового масла. Соус для пиццы не нужно варить — он приготовится прямо в духовке."),
            RecipeStep(id: UUID(), title: "Растягиваем тесто", imageSource: nil,
                       text: "Разогреваем духовку с камнем для пиццы или перевёрнутым противнем до максимума (250–270 °C). Растягиваем тесто руками в круглую лепёшку около 30 см, не используя скалку."),
            RecipeStep(id: UUID(), title: "Выпекаем", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Pizza_Margherita_stu_spivack.jpg/960px-Pizza_Margherita_stu_spivack.jpg")!,
                       text: "Наносим соус, раскладываем кусочки моцареллы. Выпекаем 8–10 минут до подрумяненного края. Сразу из духовки кладём листья базилика и сбрызгиваем оливковым маслом."),
        ],
        bottomText: nil
    ),

    // MARK: - 15. Кок о Вин

    Recipe(
        id: UUID(),
        imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Gourmet_coq_au_vin.jpg/960px-Gourmet_coq_au_vin.jpg")!,
        cookingTimeMins: 90,
        complexity: 3,
        title: "Кок о Вин",
        description: "Французская классика: курица, тушённая в красном бургундском вине с грибами, жемчужным луком и беконом.",
        ingredients: [
            Ingredient(name: "Курица (порционные куски) — 1,5 кг"),
            Ingredient(name: "Красное сухое вино — 750 мл"),
            Ingredient(name: "Бекон — 150 г"),
            Ingredient(name: "Грибы шампиньоны — 250 г"),
            Ingredient(name: "Жемчужный лук — 200 г"),
            Ingredient(name: "Чеснок — 4 зубчика"),
            Ingredient(name: "Куриный бульон — 200 мл"),
            Ingredient(name: "Томатная паста — 1 ст. л."),
            Ingredient(name: "Тимьян — 3 веточки"),
            Ingredient(name: "Лавровый лист — 2 шт."),
            Ingredient(name: "Мука — 2 ст. л."),
        ],
        topText: nil,
        steps: [
            RecipeStep(id: UUID(), title: "Маринуем курицу", imageSource: nil,
                       text: "Заливаем куски курицы вином, добавляем тимьян и лавровый лист. Маринуем 4 часа или ночь в холодильнике. Обсушиваем курицу перед приготовлением."),
            RecipeStep(id: UUID(), title: "Обжариваем", imageSource: nil,
                       text: "В жаровне обжариваем бекон кубиками, вынимаем. В жире от бекона обжариваем куски курицы, запылённые мукой, до золотистой корочки. Откладываем. Пассеруем лук и чеснок 3 минуты."),
            RecipeStep(id: UUID(), title: "Тушим в вине", imageSource: nil,
                       text: "Возвращаем курицу и бекон в жаровню. Вливаем маринад, бульон, добавляем томатную пасту. Доводим до кипения, снимаем пену. Тушим на медленном огне под крышкой 45 минут."),
            RecipeStep(id: UUID(), title: "Добавляем грибы и подаём", imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Gourmet_coq_au_vin.jpg/960px-Gourmet_coq_au_vin.jpg")!,
                       text: "Обжариваем шампиньоны на сливочном масле, добавляем в жаровню. Тушим ещё 15 минут. Подаём с картофельным пюре или хрустящим багетом, посыпав свежим тимьяном."),
        ],
        bottomText: nil
    ),
]
// swiftlint:enable line_length
