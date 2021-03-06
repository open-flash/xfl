package openfl.lang;

import com.slipshift.engine.core.Assets;

/**
 * Locale
 */
class Locale {

    public static var autoReplace: Bool = true;

    private static var localeLanguage: String = "default";
    private static var localeStrings: Map<String, String> = new Map<String, String>();
    private static var xmlPaths: Map<String, String> = new Map<String, String>();

    public static function addXMLPath(lang: String, assetName: String): Void {
        xmlPaths.set(lang, assetName);
    }

    public static function loadString(key: String): String 
    {
        var localeString: String = localeStrings.get(key);
        if (localeString == null) return key;
        localeString = StringTools.replace(localeString, "\t", "    ");
        return localeString;
    }

    public static function loadLanguageXML(language: String, callback: Bool->Void): Void
    {
        if (localeLanguage == language) return;
        localeStrings = new Map<String, String>();
        for (element in Assets.getXMLAsset(xmlPaths.get(language)).node.file.node.body.elements) {
            if (element.name == "trans-unit") {
                var key: String = element.att.resname;
                var value: String = element.node.source.innerData;
                localeStrings.set(key, value);
            }
        }
        localeLanguage = language;
        callback(true);
    }

}
