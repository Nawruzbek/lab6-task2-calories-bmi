import UIKit

class ViewController: UIViewController {
    
    // Все элементы будут созданы программно
    var ageTextField: UITextField!
    var heightTextField: UITextField!
    var weightTextField: UITextField!
    var sexSegmentedControl: UISegmentedControl!
    var activitySegmentedControl: UISegmentedControl!
    var resultLabel: UILabel!
    var calculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        // Создаём текстовые поля
        ageTextField = createTextField(placeholder: "Возраст (лет)", y: 100)
        heightTextField = createTextField(placeholder: "Рост (см)", y: 170)
        weightTextField = createTextField(placeholder: "Вес (кг)", y: 240)
        
        // Segmented Control для пола
        sexSegmentedControl = UISegmentedControl(items: ["Мужчина", "Женщина"])
        sexSegmentedControl.frame = CGRect(x: 20, y: 310, width: view.frame.width - 40, height: 30)
        sexSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(sexSegmentedControl)
        
        // Segmented Control для активности
        activitySegmentedControl = UISegmentedControl(items: ["Низкая", "Средняя", "Высокая", "Спортсмен"])
        activitySegmentedControl.frame = CGRect(x: 20, y: 370, width: view.frame.width - 40, height: 30)
        activitySegmentedControl.selectedSegmentIndex = 1
        view.addSubview(activitySegmentedControl)
        
        // Кнопка
        calculateButton = UIButton(type: .system)
        calculateButton.frame = CGRect(x: 20, y: 430, width: view.frame.width - 40, height: 44)
        calculateButton.setTitle("Рассчитать", for: .normal)
        calculateButton.backgroundColor = .systemBlue
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.layer.cornerRadius = 10
        calculateButton.addTarget(self, action: #selector(calculateTapped), for: .touchUpInside)
        view.addSubview(calculateButton)
        
        // Label для результата
        resultLabel = UILabel(frame: CGRect(x: 20, y: 500, width: view.frame.width - 40, height: 150))
        resultLabel.numberOfLines = 0
        resultLabel.text = "Введите данные и нажмите 'Рассчитать'"
        resultLabel.textAlignment = .center
        view.addSubview(resultLabel)
    }
    
    func createTextField(placeholder: String, y: CGFloat) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 20, y: y, width: view.frame.width - 40, height: 44))
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        view.addSubview(textField)
        return textField
    }
    
    @objc func calculateTapped() {
        // Получаем значения
        guard let ageText = ageTextField.text, let age = Double(ageText),
              let heightText = heightTextField.text, let height = Double(heightText),
              let weightText = weightTextField.text, let weight = Double(weightText) else {
            resultLabel.text = "Ошибка: заполните все поля числами"
            return
        }
        
        let isMale = sexSegmentedControl.selectedSegmentIndex == 0
        
        // Уровни активности
        let activityLevels: [Double] = [1.2, 1.375, 1.55, 1.725]
        let activity = activityLevels[activitySegmentedControl.selectedSegmentIndex]
        
        // BMR (Харрис-Бенедикт)
        var bmr: Double
        if isMale {
            bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        } else {
            bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)
        }
        
        let maintenanceCalories = bmr * activity
        
        // ИМТ
        let heightInMeters = height / 100.0
        let bmi = weight / (heightInMeters * heightInMeters)
        
        var bmiCategory = ""
        switch bmi {
        case ..<18.5: bmiCategory = "Недостаточный вес"
        case 18.5..<25: bmiCategory = "Нормальный вес"
        case 25..<30: bmiCategory = "Избыточный вес"
        default: bmiCategory = "Ожирение"
        }
        
        resultLabel.text = String(format: """
        BMR: %.0f ккал/день
        Калории для поддержания веса: %.0f ккал/день
        ИМТ: %.1f (%@)
        """, bmr, maintenanceCalories, bmi, bmiCategory)
    }
}
