#include <StyleSheet/Parser.h>
#include <gtest/gtest.h>

using namespace StyleSheet;

TEST(TestElement, testElement)
{
	std::string elementStr = " type_selector  {  property1: val1;  property2: val2, val3;  } ";

	CssElement element = CssElement::parse(elementStr);
	ASSERT_TRUE(element.getSelector().isType());
	ASSERT_FALSE(element.getSelector().isClass());
	ASSERT_FALSE(element.getSelector().isId());

	ASSERT_EQ(std::size_t(2), element.getPropertyCount());
	ASSERT_EQ(std::string("type_selector { property1: val1; property2: val2, val3; }"), element.toString());
}

TEST(TestElement, testElementSorting)
{
	CssElement element1 = CssElement::parse("selector1 { property1: val1; }");
	CssElement element2 = CssElement::parse("selector2 { property1: val1; }");

	ASSERT_TRUE(element1 < element2);
	ASSERT_FALSE(element2 < element1);

	CssElement element3 = CssElement::parse("type_selector  {  property1 : val1;  property2 : val2, val3;  } ");
	CssElement element4 = CssElement::parse(".class_selector { property1 : val1; property2 : val2, val3; }");

	ASSERT_TRUE(element3 < element4);
	ASSERT_TRUE(!(element4 < element3));
}

TEST(TestElement, testAddEmptyProperty)
{
	CssElement element(CssSelector::CssClassSelector("main"), CssPropertySet());

	element.addProperty(CssProperty("prop_name", ""));

	ASSERT_EQ(std::size_t(0), element.getPropertyCount());
}
