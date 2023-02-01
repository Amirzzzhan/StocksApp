#include <StyleSheet/Parser.h>
#include <gtest/gtest.h>

using namespace StyleSheet;

TEST(TestStyleSheet, testDocument)
{
	CssDocument doc;
	doc.addElement(CssElement::parse(".class_selector { property1 : val1; property2 : val2, val3; }"));
	doc.addElement(CssElement::parse("type_selector  {  property1 : val1;  property2 : val2, val3;  } "));
	doc.addElement(CssElement::parse("#id_selector { property1 : val1; }"));
	// Try to add a duplicate
	doc.addElement(CssElement::parse("#id_selector { property1 : val1; }"));

	ASSERT_EQ(std::size_t(3), doc.getElementCount());
}

TEST(TestStyleSheet, testQueryDocument)
{
	CssDocument doc;

	doc.addElement(CssElement::parse(".class_selector { property1 : val1; property2 : val2, val3; }"));
	doc.addElement(CssElement::parse("type_selector  {  property1 : val1;  property2 : val2, val3;  } "));
	doc.addElement(CssElement::parse("#id_selector { property1 : val1; }"));

	ASSERT_FALSE(doc.hasSelector(CssSelector::CssTypeSelector("type1")));
	ASSERT_TRUE(doc.hasSelector(CssSelector::CssTypeSelector("type_selector")));
	ASSERT_FALSE(doc.hasSelector(CssSelector::CssTypeSelector("class_selector")));

	ASSERT_FALSE(doc.hasSelector(CssSelector::CssClassSelector("class1")));
	ASSERT_TRUE(doc.hasSelector(CssSelector::CssClassSelector("class_selector")));
	ASSERT_FALSE(doc.hasSelector(CssSelector::CssClassSelector("id_selector")));

	ASSERT_FALSE(doc.hasSelector(CssSelector::CssIdSelector("id1")));
	ASSERT_TRUE(doc.hasSelector(CssSelector::CssIdSelector("id_selector")));
	ASSERT_FALSE(doc.hasSelector(CssSelector::CssIdSelector("type_selector")));
}

TEST(TestStyleSheet, testGetElement)
{
	CssDocument doc;

	doc.addElement(CssElement::parse(".class_selector { property1 : val1; property2 : val2, val3; }"));
	doc.addElement(CssElement::parse("type_selector  {  property1 : val1;  property2 : val2, val3; property3: val3; } "));
	doc.addElement(CssElement::parse("#id_selector { property1 : val1; }"));

	CssElement cssElement = doc.getElement(CssSelector::CssTypeSelector("type1"));
	ASSERT_EQ(std::size_t(0), cssElement.getPropertyCount());

	cssElement = doc.getElement(CssSelector::CssTypeSelector("type_selector"));
	ASSERT_EQ(std::size_t(3), cssElement.getPropertyCount());

	cssElement = doc.getElement(CssSelector::CssClassSelector("class1"));
	ASSERT_EQ(std::size_t(0), cssElement.getPropertyCount());

	cssElement = doc.getElement(CssSelector::CssClassSelector("class_selector"));
	ASSERT_EQ(std::size_t(2), cssElement.getPropertyCount());

	cssElement = doc.getElement(CssSelector::CssIdSelector("id1"));
	ASSERT_EQ(std::size_t(0), cssElement.getPropertyCount());

	cssElement = doc.getElement(CssSelector::CssIdSelector("id_selector"));
	ASSERT_EQ(std::size_t(1), cssElement.getPropertyCount());
}

TEST(TestStyleSheet, testAddEmptyElement)
{
	CssDocument doc;

	doc.addElement(CssElement(CssSelector::CssIdSelector("prova"), CssPropertySet()));
	ASSERT_EQ(std::size_t(0), doc.getElementCount());
}

TEST(TestStyleSheet, testCssStyle)
{
	CssStyle style("main", "empty_obj");

	ASSERT_EQ(std::string("main"), style.getIdSelector().getName());
	ASSERT_EQ(std::string("empty_obj"), style.getTypeSelector().getName());
	ASSERT_TRUE(style.getClassSelectors().empty());
	ASSERT_TRUE(style.getInlineProperties().empty());

	ASSERT_EQ(std::string("main"), style.getIdSelector().getName());

	style.setInlineProperties(CssPropertySet::parse("pro1: val1;"));
	ASSERT_FALSE(style.getInlineProperties().empty());
	ASSERT_EQ(std::size_t(1), style.getInlineProperties().size());
}

TEST(TestStyleSheet, testCssStyleClasses)
{
	CssStyle style("main", "empty_obj");

	ASSERT_TRUE(style.getClassSelectors().empty());
	ASSERT_TRUE(style.getInlineProperties().empty());

	style.addClass("c1");
	ASSERT_FALSE(style.getClassSelectors().empty());
	ASSERT_EQ(std::size_t(1), style.getClassSelectors().size());

	style.addClass("c2");
	ASSERT_EQ(std::size_t(2), style.getClassSelectors().size());

	style.addClass("c2");
	ASSERT_EQ(std::size_t(2), style.getClassSelectors().size());
}

TEST(TestStyleSheet, testCssStyleParseClasses)
{
	CssStyle style("main", "empty_obj");
	style.addClasses("c1 c3 c2 c2");

	ASSERT_EQ(std::size_t(3), style.getClassSelectors().size());
}

TEST(TestStyleSheet, testUseCase1)
{
	CssDocument doc;

	doc.addElement(CssElement::parse(".class_selector { property1 : val1; property2 : val2, val3; }"));
	doc.addElement(CssElement::parse("type_selector  {  property1 : val1;  property2 : val2, val3; property3: val3; } "));
	doc.addElement(CssElement::parse("#id_selector { property1 : val1; }"));

	CssStyle style("id_selector", "type");
	const CssElement& elemById = doc.getElement(style.getIdSelector());
	ASSERT_FALSE(elemById.getProperties().empty());
	ASSERT_TRUE(style.getIdSelector() == elemById.getSelector());

	const CssElement& elemByType = doc.getElement(style.getTypeSelector());
	ASSERT_TRUE(elemByType.getProperties().empty());
	ASSERT_TRUE(style.getTypeSelector() == elemByType.getSelector());
}



TEST(TestStyleSheet, testParseDocument)
{
	std::string cssDocument = "type_selector  {  property1 : val1;  property2 : val2, val3;  } \n"
		".class_selector { property1 : val1; property2 : val2, val3; }\n"
		"#id_selector { property1 : val1; property2 : val2, val3; }\n";

	CssDocument cssDoc = CssDocument::parse(cssDocument);

	ASSERT_EQ(std::size_t(3), cssDoc.getElementCount());

	std::string output =
		"type_selector { property1: val1; property2: val2, val3; }\n"
		".class_selector { property1: val1; property2: val2, val3; }\n"
		"#id_selector { property1: val1; property2: val2, val3; }\n";
	ASSERT_EQ(output, cssDoc.toString());
}

TEST(TestStyleSheet, testParseDocument1)
{
    std::string docStr =
    "body {"
        "font-family: Arial, Helvetica, sans-serif, Verdana, Geneva;"
        //"/*    font-size: small; */"
        "font-size: 75%;"
        "margin: 0;"
        "padding:0;"
        "font-weight: normal;"
    "}"
    "\n"
    "A{"
        "text-decoration: none;"
    "}"
    "\n"
    "IMG {"
        "border: 0px;"
    "}\n"
    "\n"
    ".riga_strumenti{"
        "text-align:right;"
        "color : Black;"
        "font-weight : bold;"
    "}\n"
    "#menu_strumenti{"
        "float: right;"
        "margin: 9px 55px 0px 0px;\n"
    "}\n";

    CssDocument doc = CssDocument::parse(docStr);
    ASSERT_EQ(std::size_t(5), doc.getElementCount());
    CssElement bodyElem = doc.getElement(CssSelector::CssTypeSelector("body"));
    ASSERT_EQ(std::size_t(5), bodyElem.getPropertyCount());
    CssProperty font_family = bodyElem.getProperties().getProperty("font-family");
    ASSERT_EQ(std::string("Arial, Helvetica, sans-serif, Verdana, Geneva"), font_family.getValue());

    CssElement riga_strumentiElem = doc.getElement(CssSelector::CssClassSelector("riga_strumenti"));
    ASSERT_EQ(std::size_t(3), riga_strumentiElem.getPropertyCount());

    CssElement menu_strumentiElem = doc.getElement(CssSelector::CssIdSelector("menu_strumenti"));
    ASSERT_EQ(std::size_t(2), menu_strumentiElem.getPropertyCount());
}
