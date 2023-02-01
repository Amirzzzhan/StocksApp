#include <StyleSheet/Parser.h>
#include <gtest/gtest.h>

using namespace StyleSheet;

TEST(TestParser, testCssParser)
{
	CssDocument doc;

	doc.addElement(CssElement::parse(".class_selector { property1 : val1; property2 : val2, val3; }"));
	doc.addElement(CssElement::parse("type_selector  {  property1 : val1;  property2 : val2, val3; property3: val3; } "));
	doc.addElement(CssElement::parse("#id_selector { property1 : val1; }"));

	CssParser parser(doc);

	CssStyle style("id_selector", "type");
	style.setInlineProperties(CssPropertySet::parse("inline_prop: val1;"));

	CssPropertySet properties = parser.getProperties(style);
	ASSERT_EQ(std::size_t(2), properties.size());
}

TEST(TestParser, testOverridePropertyWithInline)
{
	CssDocument doc;

	doc.addElement(CssElement::parse(".class_selector { property1 : val1; property2 : val2, val3; }"));
	doc.addElement(CssElement::parse("type_selector  {  property1 : val1;  property2 : val2, val3; property3: val3; } "));
	doc.addElement(CssElement::parse("#id_selector { property1 : val1; }"));

	CssParser parser(doc);

	CssStyle style("id", "type_selector");
	style.setInlineProperties(CssPropertySet::parse("property2: val4;"));

	CssPropertySet properties = parser.getProperties(style);
	ASSERT_EQ(std::size_t(3), properties.size());

	ASSERT_EQ(std::string("val4"), properties.getProperty("property2").getValue());
}

TEST(TestParser, testCssParserMultipleSelection)
{
	CssDocument doc;

	doc.addElement(CssElement::parse("#id_selector { property1 : val1; property2: val1; }"));
	doc.addElement(CssElement::parse("type_selector  {  property1 : val2;  property2 : val2; property3: val2; } "));
	doc.addElement(CssElement::parse(".class_selector { property1 : val3; property2 : val3; property3: val3; property4: val3; }"));

	CssParser parser(doc);

	CssStyle style("id_selector", "type_selector");
	style.setInlineProperties(CssPropertySet::parse("property1: val0;"));
	style.addClass("class_selector");
	style.addClass("class_selector_not_found");

	CssPropertySet properties = parser.getProperties(style);
	ASSERT_EQ(std::size_t(4), properties.size());

	// First Inline
	ASSERT_EQ(std::string("val0"), properties.getProperty("property1").getValue());

	// Second IdSelector
	ASSERT_EQ(std::string("val1"), properties.getProperty("property2").getValue());

	// Third TypeSelector
	ASSERT_EQ(std::string("val2"), properties.getProperty("property3").getValue());

	// Then class selectors
	ASSERT_EQ(std::string("val3"), properties.getProperty("property4").getValue());
}

TEST(TestParser, testCssParserMultipleClasses1)
{
	CssDocument doc;

	doc.addElement(CssElement::parse(".class_selector1 { property1 : val1; property2: val1; }"));
	doc.addElement(CssElement::parse(".class_selector2  {  property1 : val2;  property2 : val2; property3: val2; } "));
	doc.addElement(CssElement::parse(".class_selector3 { property1 : val3; property2 : val3; property3: val3; property4: val3; }"));

	CssParser parser(doc);

	CssStyle style("id_selector", "type_selector");
	style.setInlineProperties(CssPropertySet::parse("property1: val0;"));
	style.addClass("class_selector1");
	style.addClass("class_selector_not_found");
	style.addClass("class_selector3");

	CssPropertySet properties = parser.getProperties(style);
	ASSERT_EQ(std::size_t(4), properties.size());

	// First Inline
	ASSERT_EQ(std::string("val0"), properties.getProperty("property1").getValue());

	// Second class selectors
	ASSERT_EQ(std::string("val1"), properties.getProperty("property2").getValue());

	ASSERT_EQ(std::string("val3"), properties.getProperty("property3").getValue());

	ASSERT_EQ(std::string("val3"), properties.getProperty("property4").getValue());
}

TEST(TestParser, testCssParserMultipleClasses2)
{
	CssDocument doc;

	doc.addElement(CssElement::parse(".class_selector1 { property1 : val1; property2: val1; }"));
	doc.addElement(CssElement::parse(".class_selector2  {  property1 : val2;  property2 : val2; property3: val2; } "));
	doc.addElement(CssElement::parse(".class_selector3 { property1 : val3; property2 : val3; property3: val3; property4: val3; }"));

	CssParser parser(doc);

	CssStyle style("id_selector", "type_selector");
	style.setInlineProperties(CssPropertySet::parse("property1: val0;"));
	style.addClass("class_selector3");
	style.addClass("class_selector_not_found");
	style.addClass("class_selector1");

	CssPropertySet properties = parser.getProperties(style);
	ASSERT_EQ(std::size_t(4), properties.size());

	// First Inline
	ASSERT_EQ(std::string("val0"), properties.getProperty("property1").getValue());

	// Second class selectors
	ASSERT_EQ(std::string("val3"), properties.getProperty("property2").getValue());

	ASSERT_EQ(std::string("val3"), properties.getProperty("property3").getValue());

	ASSERT_EQ(std::string("val3"), properties.getProperty("property4").getValue());
}
