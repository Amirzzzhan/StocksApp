#include <StyleSheet/Parser.h>
#include <gtest/gtest.h>

using namespace StyleSheet;

TEST(TestSelector, testTypeSelectorCtor)
{
	std::string selectorStr = "typeSelector";
	CssSelector selector = CssSelector::CssTypeSelector(selectorStr);
	ASSERT_TRUE(selector.isType());
	ASSERT_FALSE(selector.isClass());
	ASSERT_FALSE(selector.isId());
	ASSERT_EQ(selectorStr, selector.getName());
	ASSERT_EQ(selectorStr, selector.toString());
}

TEST(TestSelector, testTypeSelectorParse)
{
	std::string selectorStr = "typeSelector";
	CssSelector selector = CssSelector::parse(selectorStr);
	ASSERT_TRUE(selector.isType());
	ASSERT_FALSE(selector.isClass());
	ASSERT_FALSE(selector.isId());
	ASSERT_EQ(selectorStr, selector.getName());
	ASSERT_EQ(selectorStr, selector.toString());
}

TEST(TestSelector, testClassSelectorCtor)
{
	std::string selectorStr = "classSelector";
	CssSelector selector = CssSelector::CssClassSelector(selectorStr);
	ASSERT_FALSE(selector.isType());
	ASSERT_TRUE(selector.isClass());
	ASSERT_FALSE(selector.isId());
	ASSERT_EQ(selectorStr, selector.getName());
	ASSERT_EQ(std::string(".") + selectorStr, selector.toString());
}

TEST(TestSelector, testClassSelectorParse)
{
	std::string selectorStr = "classSelector";
	CssSelector selector = CssSelector::parse(std::string(".") + selectorStr);
	ASSERT_FALSE(selector.isType());
	ASSERT_TRUE(selector.isClass());
	ASSERT_FALSE(selector.isId());
	ASSERT_EQ(selectorStr, selector.getName());
	ASSERT_EQ(std::string(".") + selectorStr, selector.toString());
}

TEST(TestSelector, testIdSelectorCtor)
{
	std::string selectorStr = "main";
	CssSelector selector = CssSelector::CssIdSelector(selectorStr);
	ASSERT_FALSE(selector.isType());
	ASSERT_FALSE(selector.isClass());
	ASSERT_TRUE(selector.isId());
	ASSERT_EQ(selectorStr, selector.getName());
	ASSERT_EQ(std::string("#") + selectorStr, selector.toString());
}

TEST(TestSelector, testIdSelectorParse)
{
	std::string selectorStr = "main";
	CssSelector selector = CssSelector::parse(std::string("#") + selectorStr);
	ASSERT_FALSE(selector.isType());
	ASSERT_FALSE(selector.isClass());
	ASSERT_TRUE(selector.isId());
	ASSERT_EQ(selectorStr, selector.getName());
	ASSERT_EQ(std::string("#") + selectorStr, selector.toString());
}

TEST(TestSelector, testEmptySelector)
{
	std::string sel = "";
	ASSERT_THROW(CssSelector::parse(sel), std::invalid_argument);

	ASSERT_THROW(CssSelector::CssTypeSelector(sel), std::invalid_argument);
	ASSERT_THROW(CssSelector::CssIdSelector(sel), std::invalid_argument);
	ASSERT_THROW(CssSelector::CssClassSelector(sel), std::invalid_argument);
}

TEST(TestSelector, testSelectorSorting)
{
	CssSelector selector1 = CssSelector::parse("main1");
	CssSelector selector2 = CssSelector::parse(".main1");
	CssSelector selector3 = CssSelector::parse(".main2");
	CssSelector selector4 = CssSelector::parse("#main2");


	ASSERT_TRUE(selector1 < selector2);
	ASSERT_FALSE(selector2 < selector1);
	ASSERT_TRUE(selector2 < selector3);
	ASSERT_FALSE(selector3 < selector2);
	ASSERT_TRUE(selector3 < selector4);
	ASSERT_FALSE(selector4 < selector3);

	CssSelector selector5 = CssSelector::parse("type_selector");
	CssSelector selector6 = CssSelector::parse(".class_selector");

	ASSERT_TRUE(selector5 < selector6);
	ASSERT_FALSE(selector6 < selector5);
}

TEST(TestSelector, testSelectorEquality)
{
	CssSelector selector1 = CssSelector::parse("main1");
	CssSelector selector2 = CssSelector::parse(".main1");
	CssSelector selector3 = CssSelector::parse(".main1");
	CssSelector selector4 = CssSelector::parse("#main1");

	ASSERT_TRUE(selector1 != selector2);
	ASSERT_TRUE(selector2 == selector3);
	ASSERT_TRUE(selector3 != selector4);
}
