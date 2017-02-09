//
//  ViewController.swift
//  PayPalDemo
//
//  Created by Felipe Díaz on 08/02/17.
//  Copyright © 2017 FDM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PayPalPaymentDelegate {

    // MARK: - Propiedades
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfiguration = PayPalConfiguration()
    
    // MARK: - Metodos del ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Cambiar ajustes del SDK
        self.payPalConfiguration.acceptCreditCards = false // Se aceptará tambien pagos con tarjeta de crédito?
        self.payPalConfiguration.merchantName = "MI EMPRESA"
        self.payPalConfiguration.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        self.payPalConfiguration.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PayPalMobile.preconnect(withEnvironment: environment) // Utilizado para acelerar la conexion con PayPal cuando se realice
    }
    //
    
    // MARK: - PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("Pago Cancelado")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment)
    {
        print("Pago exitoso!")
        
        paymentViewController.dismiss(animated: true, completion:
        { () -> Void in
            let response = completedPayment.confirmation["response"] as! Dictionary<String, Any>
            let fecha = response["create_time"] as! String
            let id = response["id"] as! String
            print("Fecha: \(fecha)")
            print("Id: \(id)")
        })
    }
    
    //MARK: - UI Methods
    @IBAction func paymentAction(_ sender: Any) {
        //TODO: Establecer elemetos de la compra
        let item1 = PayPalItem(name: "Curso 1",
                               withQuantity: 1,
                               withPrice: NSDecimalNumber(decimal: 150.00),
                               withCurrency: "MXN",
                               withSku: "CURSO-001")
        
        let subtotal = PayPalItem.totalPrice(forItems: [item1])

        // Elementos opcionales
        let envio = NSDecimalNumber(decimal: 0.00)
        let impuestos = NSDecimalNumber(decimal: subtotal.decimalValue*0.16)
        let detallesPago = PayPalPaymentDetails(subtotal: subtotal, withShipping: envio, withTax: impuestos)
        
        let total = subtotal.adding(envio).adding(impuestos)
        
        let payment = PayPalPayment(amount: total, currencyCode: "MXN", shortDescription: "MI EMPRESA", intent: .sale)
        
        payment.items = [item1]
        payment.paymentDetails = detallesPago
        
        if (payment.processable)
        {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: self.payPalConfiguration, delegate: self)
            self.present(paymentViewController!, animated: true, completion: nil)
        }
        else
        {
            print("El pago no puede ser procesado, verifique no tenga un monto mayor a cero y tenga una descripción válida: \(payment)")
        }

    }

}

