package com.project.mapper;

import java.util.List; 

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.project.model.krhBoardVO;
import com.project.model.krhReportVO;

@Mapper
public interface krhBoardMapper {
	// 전체 게시글 수 조회 + 검색
    @Select({
        "<script>",
        "SELECT COUNT(*) FROM board",
        "<where>",
        "<if test='findStr != null and findStr != \"\"'>",
        "title LIKE CONCAT('%', #{findStr}, '%')",
        "</if>",
        "</where>",
        "</script>"
    })
    int countBoard(@Param("findStr") String findStr);

    // 페이징 후 게시글 조회 + 검색
    @Select({
        "<script>",
        "SELECT * FROM board",
        "<where>",
        "<if test='findStr != null and findStr != \"\"'>",
        "title LIKE CONCAT('%', #{findStr}, '%')",
        "</if>",
        "</where>",
        "ORDER BY createdAt DESC",
        "LIMIT #{start}, #{size}",
        "</script>"
    })
    List<krhBoardVO> getBoardList(@Param("start") int start, 
                                  @Param("size") int size, 
                                  @Param("findStr") String findStr);

    // 단건 조회
    @Select("SELECT * FROM board WHERE boardId=#{boardId}")
    krhBoardVO getBoardById(@Param("boardId") int boardId);

    // 조회수 증가
    @Update("UPDATE board SET views = views + 1 WHERE boardId=#{boardId}")
    void incrementViews(@Param("boardId") int boardId);

    // 게시글 추가
    @Insert("INSERT INTO board(title, author, authorId, content, authorEmail, createdAt) " +
            "VALUES (#{title}, #{author}, #{authorId}, #{content}, #{authorEmail}, NOW())")
    void insertBoard(krhBoardVO board);

    // 게시글 수정
    @Update("UPDATE board SET title=#{title}, content=#{content}, updatedAt=NOW() WHERE boardId=#{boardId}")
    int updateBoard(krhBoardVO board);

    // 게시글 삭제
    @Delete("DELETE FROM board WHERE boardId=#{boardId} AND authorEmail=#{authorEmail}")
    void deleteBoard(@Param("boardId") int boardId, @Param("authorEmail") String authorEmail);

    // 게시글 신고
    @Insert("INSERT INTO reports(boardId, reporterId, reporter, reason, reportedAt) " +
            "VALUES(#{boardId}, #{reporterId}, #{reporter}, #{reason}, NOW())")
    void reportBoard(krhReportVO report);

    // 신고 여부 확인
    @Select("SELECT COUNT(*) > 0 FROM reports WHERE boardId=#{boardId} AND reporterId=#{reporterId}")
    boolean isBoardReported(@Param("boardId") int boardId, @Param("reporterId") long reporterId);

    // 좋아요 상태 조회
    @Select("SELECT likeType FROM boardLike WHERE boardId=#{boardId} AND userEmail=#{userEmail}")
    String getLikeStatus(@Param("boardId") int boardId, @Param("userEmail") String userEmail);

    // 좋아요/싫어요 상태 업데이트
    @Insert("INSERT INTO boardLike(boardId, userEmail, likeType) " +
            "VALUES (#{boardId}, #{userEmail}, #{status}) " +
            "ON DUPLICATE KEY UPDATE likeType = #{status}")
    void updateLikeStatus(@Param("boardId") int boardId, @Param("userEmail") String userEmail, @Param("status") String status);

    // 좋아요 갯수
    @Select("SELECT COUNT(*) FROM boardLike WHERE boardId=#{boardId} AND likeType='like'")
    int getLikeCount(@Param("boardId") int boardId);

    // 싫어요 갯수
    @Select("SELECT COUNT(*) FROM boardLike WHERE boardId=#{boardId} AND likeType='dislike'")
    int getDislikeCount(@Param("boardId") int boardId);

    // 좋아요/싫어요 취소
    @Update("UPDATE boardLike SET likeType='none' WHERE boardId=#{boardId} AND userEmail=#{userEmail}")
    void removeLikeStatus(@Param("boardId") int boardId, @Param("userEmail") String userEmail);

    // 게시글 작성자 이메일 조회
    @Select("SELECT authorEmail FROM board WHERE boardId=#{boardId}")
    String getUserbyBoardId(@Param("boardId") int boardId);
}
