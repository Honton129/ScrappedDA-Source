package backend.api.cpp;

import backend.api.cpp.WindowsData;

class CppAPI
{
	#if (cpp && windows)
	public static function darkMode()
	{
		WindowsData.setWindowColorMode(DARK);
	}

	public static function lightMode()
	{
		WindowsData.setWindowColorMode(LIGHT);
	}

	public static function setWindowOppacity(a:Float)
	{
		WindowsData.setWindowAlpha(a);
	}

	public static function _setWindowLayered()
	{
		WindowsData._setWindowLayered();
	}
	#end
}