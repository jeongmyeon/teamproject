package com.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.mybatis.spring.annotation.MapperScan;

import com.project.model.Recipes;
import com.project.model.krhMainVO;

@Mapper
public interface krhMainMapper {
	// 인기 레시피 조회 (recipes db에서)
    @Select("SELECT foodName, recipes_id, foodImg, view " +
            "FROM recipes " +
            "ORDER BY view DESC " +
            "LIMIT 4")
    List<Recipes> popularRecipe();

    // 최신 레시피 조회
    @Select("SELECT foodName, recipes_id, foodImg, view " +
            "FROM recipes " +
            "ORDER BY recipes_id DESC " +
            "LIMIT 4")
    List<Recipes> recentRecipe();

    // 사용자의 관심 목록에서 가장 많이 등장한 카테고리의 레시피 추천
    @Select("SELECT r.recipes_id, r.foodName, r.foodImg, r.view " +
            "FROM recipes r " +
            "WHERE r.category_id = ( " +
            "   SELECT category_id " +
            "   FROM favorite f " +
            "   JOIN recipes r2 ON f.recipe_id = r2.recipes_id " +
            "   WHERE f.user_id = #{userId} " +
            "   GROUP BY r2.category_id " +
            "   ORDER BY COUNT(*) DESC " +
            "   LIMIT 1 " +
            ") " +
            "ORDER BY RAND() " +
            "LIMIT 4")
    List<Recipes> getRecommendedRecipes(long userId);
}