package com.iagd.jsonmodelkit

class FontSizeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let inputString = inputValues?.values.first as? String,
        let sizeValue = Double(inputString)
        {
            if UIDevice.fontShrinkingEnabled
            {
                return sizeValue * 0.8
            }

            return sizeValue
        }
        */
        return null
    }
}
/*
var fontNames = ["font_name_regular"    : "Roboto-Regular",
"font_name_medium"     : "Roboto-Medium",
"font_name_semi_bold"  : "Crossten-SemiBold",
"font_name_picto"      : "icomoon",
"font_name_bold"       : "Roboto-Bold"]
*/
class FontTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?) : Any?
    {
        /*
        var fontNameKey : String?

        if let key = inputValues?["font_key"] as? String {
            fontNameKey = key
        }

        if let key = inputValues?["font_bold_key"] as? String {
            fontNameKey = key
        }

        if let key = inputValues?["font_selected_key"] as? String {
            fontNameKey = key
        }

        if let fontNameKey = fontNameKey,
        let fontName = fontNames[fontNameKey],
        let fontSize = inputValues?["size"] as? String,
        let sizeValue = Double(fontSize)
        {
            if UIDevice.fontShrinkingEnabled
            {
                return  UIFont(name: fontName, size: CGFloat(sizeValue * 0.8))!
            }

            return UIFont(name: fontName, size:  CGFloat(sizeValue * 1.06))!
        }
        */
        return null
    }
}

class FontKeyTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let key = inputValues?["font_key"] as? String,
        let fontName = fontNames[key]
        {
            return fontName
        }
        */
        return null
    }
}

class TradeFieldTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {

        /*
        if let inputString = inputValues?.values.first as? String
                {
                    if inputString == "quote" {
                        return TradeFieldType.quote
                    }

                    if inputString == "base" {
                        return TradeFieldType.base
                    }
                }
        */
        return null
    }
}

class JMUserAccountStateTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {

        /*
        if let inputString = inputValues?.values.first as? String
                {
                    if inputString == "quote" {
                        return TradeFieldType.quote
                    }

                    if inputString == "base" {
                        return TradeFieldType.base
                    }
                }
        */
        return null
    }
}

class PricedPairStatsTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let statsArray = inputValues?.values.first as?  [[String : Any]]
        {
            var statsDictionary = [Int : Double]()

            for stats in statsArray
            {
                if let hoursAgo = stats["period"] as? Int,
                let priceString = stats["price"] as? String
                {
                    statsDictionary[hoursAgo] = Double(priceString)
                }
            }

            return statsDictionary
        }
        */
        return null
    }
}

class FormPageTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {

        /*
        if let type = inputValues?.values.first as? String
                {
                    switch type {
                        case "form":
                        return FormPageType.form
                        case "emailVerify":
                        return FormPageType.emailVerify
                        case "interstitial":
                        return FormPageType.interstitial
                        case "plaid":
                        return FormPageType.plaid
                        default:
                        return null
                    }
                }
         */
        return null
    }
}

class FormActionTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let type = inputValues?.values.first as? String
                {
                    switch type {
                        case "signup":
                        return FormActionType.signup
                        case "login":
                        return FormActionType.login
                        case "forgotPassword":
                        return FormActionType.forgotPassword
                        case "resetPassword":
                        return FormActionType.resetPassword
                        case "updatePassword":
                        return FormActionType.updatePassword
                        case "updateAccount":
                        return FormActionType.updateAccount
                        case "createPhone":
                        return FormActionType.createPhone
                        case "verifyPhone":
                        return FormActionType.verifyPhone
                        case "reverifyPhone":
                        return FormActionType.reverifyPhone
                        case "createAddress":
                        return FormActionType.createAddress
                        case "linkAccount":
                        return FormActionType.linkAccount
                        case "confirmAccount":
                        return FormActionType.confirmAccount
                        case "dismiss":
                        return FormActionType.dismiss
                        case "tradeNow":
                        return FormActionType.tradeNow
                        case "viewTOS":
                        return FormActionType.viewTOS
                        case "contactUS":
                        return FormActionType.contactUS
                        case "openEmail":
                        return FormActionType.openEmail
                        case "nextPage":
                        return FormActionType.nextPage
                        case "signout":
                        return FormActionType.signout
                        case "unlock":
                        return FormActionType.unlock
                        case "resendEmail":
                        return FormActionType.resendEmail
                        case "fundNow":
                        return FormActionType.fundNow
                        case "acceptNewTerms":
                        return FormActionType.acceptNewTerms
                        case "requestNotification":
                        return FormActionType.requestNotification
                        case "requestStateNotification":
                        return FormActionType.requestStateNotification
                        default:
                        return null
                    }
                }
                */
        return null
    }
}

class FormMethodTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {/*
        if let typeValue = inputValues![apiMethodTypeKey] as? String
        {

            switch typeValue {
                case "PUT":
                return FormMethodType.PUT
                case "PATCH":
                return FormMethodType.PATCH
                case "GET":
                return FormMethodType.GET
                case "DELETE":
                return FormMethodType.DELETE
                case "POST":
                return FormMethodType.POST
                default:
                return null
            }
        }
        */
        return null
    }
}

class FormFieldTemplateTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {/*
        if let typeValue = inputValues![templateTypeKey] as? String
        {
            switch typeValue {
                case "text":
                return FormFieldTemplateType.text
                case "email":
                return FormFieldTemplateType.email
                case "password":
                return FormFieldTemplateType.password
                case "createPassword":
                return FormFieldTemplateType.createPassword
                case "address":
                return FormFieldTemplateType.address
                case "name":
                return FormFieldTemplateType.name
                case "phone":
                return FormFieldTemplateType.phone
                case "verifyPhone":
                return FormFieldTemplateType.verifyPhone
                case "dateOfBirth":
                return FormFieldTemplateType.dateOfBirth
                case "socialSecurity":
                return FormFieldTemplateType.socialSecurity
                case "stateZip":
                return FormFieldTemplateType.stateZip
                default:
                return null
            }
        }
        */
        return null
    }
}

class UIColorTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let typeValue = inputValues?.values.first as? String,
        let color = UIColor(mg_hexString: typeValue)
        {
            return color
        }
        */
        return null
    }
}
/*
extension UIColor {

    public convenience init?(mg_hexString hexString: String, withAlpha alpha : CGFloat? = 1.0)
    {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#")
        {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            if hexColor.count == 8
            {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber)
                {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(alpha ?? 1.0)
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return null
    }
}
*/
class OrderSideTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let type = inputValues?.values.first as? String,
        let side = OrderSide(rawValue: type)
        {
            return side
        }
*/
        return null
    }
}

class OrderTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let type = inputValues?.values.first as? String,
        let side = OrderType(rawValue: type)
        {
            return side
        }
*/
        return null
    }
}

class OrderStatusTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let type = inputValues?.values.first as? String,
        let status = OrderStatus(rawValue: type)
        {
            return status
        }
*/
        return null
    }
}


class DateTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let dateString = inputValues?.values.first as? String,
        let date = SDKConfig.dateFormatter.date(from: dateString)
        {
            return date
        }
*/
        return null
    }
}
/*
public struct SDKConfig
{
    static public var logAPICalls  : Bool = false

    static let dateFormatter              = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
}

extension DateFormatter
{
    convenience init(withFormat format : String)
    {
        self.init()
        dateFormat = format
    }
}
*/

class FundTransactionTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let type = inputValues?.values.first as? Int,
        let transactionType = FundTransactionType(rawValue: type)
        {
            return transactionType
        }
*/
        return null
    }
}

class FundTransactionStateTransformer : JMTransformerProtocol
{

    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
   /*
        if let type = inputValues?.values.first as? String,
        let transactionState = FundTransactionState(rawValue: type.lowercased())
        {
            return transactionState
        }
        else if let type = inputValues?.values.first as? Int {

        switch type {
            case 0, 1,2, 3, 4, 5:
            return FundTransactionState.processing
            case 6:
            return FundTransactionState.complete
            case 101:
            return FundTransactionState.rejected
            case 102:
            return FundTransactionState.rejected
            default:
            break
        }

        return null
    }
*/
        return null
    }
}

class TradeShortCutTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let symbol = inputValues?["asset_symbol"] as? String,
        let format = inputValues?["format"] as? String,
        let values = inputValues?["shortcuts"] as? [Double]
        {
            var shortcuts = [TradeShortcutType]()

            for value in values
            {
                switch format {
                    case "currency":
                    shortcuts.append(TradeShortcutType.currency(value: value, currencySymbol: symbol))
                    case "decimal":
                    shortcuts.append(TradeShortcutType.decimal(value: value, currencySymbol: symbol))
                    case "percentage":
                    shortcuts.append(TradeShortcutType.percentage(value: value))
                    default:
                    break

                }
            }

            return shortcuts
        }

        */
        return null
    }
}

class AssetDetailCellConfigTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        /*
        if let configs = inputValues?.values.first as? [[String : AnyObject]]
        {
            var cellConfigs = [DetailCellConfig]()

            for json in configs
            {
                if let config = DetailCellConfig(json) {
                    cellConfigs.append(config)
                }

            }

            return cellConfigs
        }
        */
        return null
    }
}

class QuoteAssetIdTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}
class HTMLDesctiptionTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class AddressCityTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class AddressZipTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class AddressStreetTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class JMOrderSideTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class JMOrderStatusTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class JMPricedPairStatsTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class JMFundTransactionTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class BaseAssetIdTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class AddressCountryTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class AddressStreetNumberTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class JMDateTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class NewsDateTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class JMOrderTypeTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class AddressStateTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}

class JMFundTransactionStateTransformer : JMTransformerProtocol
{
    override fun transformValues(inputValues: HashMap<String, Any>?): Any?
    {
        return null
    }
}