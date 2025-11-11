package com.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.project.model.UserRecipe;

@Mapper
public interface krhUserRecipeMapper {
	
	 // 레시피 추가
    @Insert("INSERT INTO user_recipes (foodName, foodTime, foodImg, category_id, user_id, " +
            "step1, step2, step3, step4, step5, step6, " +
            "stepImg1, stepImg2, stepImg3, stepImg4, stepImg5, stepImg6) " +
            "VALUES (#{foodName}, #{foodTime}, #{foodImg}, #{categoryId}, #{userId}, " +
            "#{step1}, #{step2}, #{step3}, #{step4}, #{step5}, #{step6}, " +
            "#{stepImg1}, #{stepImg2}, #{stepImg3}, #{stepImg4}, #{stepImg5}, #{stepImg6})")
    void insertUserRecipe(UserRecipe userRecipe);

    // 재료 추가 (존재하지 않으면 추가)
    @Insert("INSERT INTO ingredients (name) " +
            "SELECT #{ingredient} " +
            "WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = #{ingredient})")
    void insertIngredientsIfNotExist(@Param("ingredient") String ingredient);

    // 레시피-재료 연결
    @Insert("INSERT INTO recipe_ingredients (user_recipes_id, ingredient_id) " +
            "VALUES (#{userRecipesId}, #{ingredientId})")
    void linkUserRecipeIngredient(@Param("userRecipesId") Long userRecipesId, @Param("ingredientId") long ingredientId);

    // 재료 ID 조회
    @Select("SELECT ingredient_id FROM ingredients WHERE name = #{ingredient}")
    long getIngredientIdByName(@Param("ingredient") String ingredient);
}