#include <StyleSheet/Parser.h>
#include <gtest/gtest.h>

using namespace StyleSheet;

TEST(TestProperty, testPropertyCtor)
{
	CssProperty prop("property1", "val1");
  ASSERT_TRUE(prop.isValid());
	ASSERT_EQ(std::string("property1"), prop.getName());
	ASSERT_EQ(std::string("val1"), prop.getValue());
	ASSERT_EQ(std::string("property1: val1;"), prop.toString());
}

TEST(TestProperty, testPropertyParse)
{
	std::string propertyStr = " property1 : val1 ; ";
	CssProperty prop = CssProperty::parse(propertyStr);
	
  ASSERT_TRUE(prop.isValid());
  ASSERT_EQ(std::string("property1"), prop.getName());
	ASSERT_EQ(std::string("val1"), prop.getValue());
	ASSERT_EQ(std::string("property1: val1;"), prop.toString());
}

TEST(TestProperty, testPropertyParseWithNewline)
{
	std::string propertyStr = " property1 : \r\nval1 ; ";
	CssProperty prop = CssProperty::parse(propertyStr);

  ASSERT_TRUE(prop.isValid());
  ASSERT_EQ(std::string("property1"), prop.getName());
	ASSERT_EQ(std::string("val1"), prop.getValue());
	ASSERT_EQ(std::string("property1: val1;"), prop.toString());
}

TEST(TestProperty, testPropertySorting1)
{
	CssProperty prop1 = CssProperty::parse("prop1: val1;");
	CssProperty prop2 = CssProperty::parse("prop2: val1;");

	ASSERT_TRUE(prop1 < prop2);
	ASSERT_FALSE(prop2 < prop1);
}

TEST(TestProperty, DISABLED_testPropertySorting2)
{
	CssProperty prop1 = CssProperty::parse("prop1: val1;");
	CssProperty prop2 = CssProperty::parse("prop1: val2;");

	ASSERT_TRUE(prop1 < prop2);
	ASSERT_FALSE(prop2 < prop1);
}

TEST(TestPropertySet, testEmpty)
{
	CssPropertySet propertySet;

	ASSERT_TRUE(propertySet.empty());
	ASSERT_EQ(std::size_t(0), propertySet.size());
  CssProperty p1 = propertySet.getProperty("p1");
  ASSERT_FALSE(p1.isValid());
  ASSERT_EQ(CssProperty::Empty().getName(), p1.getName());
  ASSERT_EQ(CssProperty::Empty().getValue(), p1.getValue());
}

TEST(TestPropertySet, testParse)
{
	std::string propertiesStr = "   property1: val1;   property2: val2, val3;   ";
	CssPropertySet propertySet = CssPropertySet::parse(propertiesStr);

	ASSERT_FALSE(propertySet.empty());
	ASSERT_EQ(std::size_t(2), propertySet.size());
}

TEST(TestPropertySet, testGetProperty)
{
	std::string propertiesStr = "   property1: val1;   property2: val2, val3;   ";
	CssPropertySet propertySet = CssPropertySet::parse(propertiesStr);

	ASSERT_FALSE(propertySet.empty());
	ASSERT_EQ(std::size_t(2), propertySet.size());

  ASSERT_TRUE(propertySet.getProperty("property1").isValid());
  ASSERT_EQ(std::string("property1"), propertySet.getProperty("property1").getName());
  ASSERT_EQ(std::string("val1"), propertySet.getProperty("property1").getValue());
  ASSERT_EQ(std::string("property2"), propertySet.getProperty("property2").getName());
  ASSERT_EQ(std::string("val2, val3"), propertySet.getProperty("property2").getValue());
}

TEST(TestPropertySet, testToString)
{
	std::string propertiesStr = "   property1: val1;   property2: val2, val3;   ";
	CssPropertySet propertySet = CssPropertySet::parse(propertiesStr);

  ASSERT_EQ(std::string("property1: val1; property2: val2, val3; "), propertySet.toString());
}
