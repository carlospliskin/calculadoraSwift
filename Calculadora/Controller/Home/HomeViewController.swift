//
//  HomeViewController.swift
//  Calculadora
//
//  Created by carlos paredes on 10/08/21.
//

import UIKit


final class HomeViewController: UIViewController {
    
    // MARK: -Outlets
    
    // MARK: - result
    @IBOutlet weak var resultLabel: UILabel!
    // MARK: - numbers
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    // MARK: - operators
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorpercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    // MARK: - Variables
    
    private var total: Double = 0                    // Total
    private var temp: Double  = 0                    // Valor por pantalla
    private var operating = false             //indicar si se ha selecciona un operador
    private var decimal = false                     //indicar si el valor es decimal
    private var operation: OperationType = .none    //operacion actual
    
    // MARK: - Costantes
    
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kTotal = "total"
    
    private enum OperationType{

        case none, addiction, substraction, multiplication, division, percent
    }
    
    //Formateador de valores auxiliar
    
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumIntegerDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    //Formateador de valores auxiliar total
    
    private let auxTotalFormatter: NumberFormatter = { //capas de contar los digitos
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumIntegerDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    //Formateador de valores por pantalla por defecto
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
        
    }()
    
    //formateo de valores por pantalla en formato cientifico
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific //en ves de decimal es scientific
        formatter.maximumFractionDigits = 3 // si es mas de 3
        formatter.exponentSymbol = "e"//simbolo exponencial
        return formatter
    }()
    
    // MARK: - Initialization
    
    init() {//inicializacion de un xib con un controlador
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        total = UserDefaults.standard.double(forKey: kTotal)
        
        result()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //UI
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        operatorAC.round()
        operatorResult.round()
        operatorAddition.round()
        operatorDivision.round()
        operatorSubstraction.round()
        operatorMultiplication.round()
        operatorPlusMinus.round()
        operatorpercent.round()
    }

    // MARK: -  Button Actions
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        
        clear()
        
        sender.shine()
        
    }
    @IBAction func operatoMinusPlusAction(_ sender: UIButton) {
        
        temp = temp * (-1)
        
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
        
    }
    @IBAction func operatorpercentAction(_ sender: UIButton) {
        
        if operation != .percent{
            result()
        }
        operating = true
        operation = .percent
        result()
        
        sender.shine()
        
    }
    @IBAction func operatorResultAction(_ sender: UIButton) {
        
        result()
        
        sender.shine()
        
    }
    @IBAction func operatorAdditionAction(_ sender: UIButton) {
        if operation != .none{
            result()
        }
    
        operating = true
        operation = .addiction
        sender.selectOperation(true)
        sender.shine()
        
    }
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        if operation != .none{
            result()
        }
        operating = true
        operation = .substraction
        sender.selectOperation(true)
        sender.shine()
        
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none{
            result()
        }
        operating = true
        operation = .multiplication
        sender.selectOperation(true)
        sender.shine()
        
    }
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        if operation != .none{
            result()
        }
        operating = true
        operation = .division
        sender.selectOperation(true)
        sender.shine()
        
    }
    
    @IBAction func numberDedicmalAction(_ sender: UIButton) {
        
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        
        selectVisualOperation()
        
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        
        operatorAC.setTitle("C", for: .normal)
        
        var currenttemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currenttemp.count >= kMaxLength{   //no sobre pase los valores
            return
        }
        
        currenttemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        //hemos seleccionado una operacion
        if operating{
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currenttemp = ""
            
            operating = false
        }
        //hemos seleccionado decimales
        if decimal{
            currenttemp = "\(currenttemp)\(kDecimalSeparator)"
            /* existen dos tipos de concatenacion una con el simbolo + y la otra ^ entre "" */
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currenttemp + String(number))! //number pasara a ser un string
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))

        selectVisualOperation()
        
        sender.shine()
        
    }
    
    //  MARK: - LIMPIAR LOS VALORES
    
    private func clear(){
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0{
            temp = 0
            resultLabel.text = "0"
        }else{
            total = 0
            result()
        }
    }
    //obtiene el resultado final
    private func result(){
        
        switch operation {
        
        case .none:
            // No hacemos nada
            
            break
        case .addiction:
            total = total + temp
            break
        case .substraction:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
        }
        
        //formateo en pantalla
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        }else{
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("total: \(total)")
    }
    //muestra de forma visual la operacion seleccionada
    private func selectVisualOperation(){

        if !operating{
            //no estamos operando
            operatorAddition.selectOperation(false)
            operatorSubstraction.selectOperation(false)
            operatorDivision.selectOperation(false)
            operatorMultiplication.selectOperation(false)
        }else{
            switch operation {
            case .none, .percent:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorDivision.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                break
            case .addiction:
                operatorAddition.selectOperation(true)
                operatorSubstraction.selectOperation(false)
                operatorDivision.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                break
            case .substraction:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(true)
                operatorDivision.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                break
            case .multiplication:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorDivision.selectOperation(false)
                operatorMultiplication.selectOperation(true)
                break
            case .division:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorDivision.selectOperation(true)
                operatorMultiplication.selectOperation(false)
                break
            }
        }
    }
}
