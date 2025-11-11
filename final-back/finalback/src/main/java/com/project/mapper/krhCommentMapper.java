package com.project.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.project.model.krhCommentVO;

@Mapper
public interface krhCommentMapper {
	// 댓글 목록 조회 (일반 댓글만)
    @Select("SELECT * FROM comment " +
            "WHERE boardId = #{boardId} AND replyId = 0 " +
            "ORDER BY createdAt ASC, commentId ASC")
    List<krhCommentVO> commentList(@Param("boardId") int boardId);

    // 대댓글 목록 조회
    @Select("SELECT * FROM comment " +
            "WHERE replyId = #{commentId} " +
            "ORDER BY createdAt ASC, commentId ASC")
    List<krhCommentVO> commentListReply(@Param("commentId") int commentId);

    // 댓글 추가
    @Insert("INSERT INTO comment(boardId, author, authorId, authorEmail, content, replyId, createdAt) " +
            "VALUES (#{boardId}, #{author}, #{authorId}, #{authorEmail}, #{content}, 0, NOW())")
    void addComment(krhCommentVO krhcommentVo);

    // 대댓글 추가
    @Insert("INSERT INTO comment(boardId, author, authorId, authorEmail, content, replyId, createdAt) " +
            "VALUES (#{boardId}, #{author}, #{authorId}, #{authorEmail}, #{content}, #{replyId}, NOW())")
    void addReply(krhCommentVO krhcommentVo);

    // 댓글 수정
    @Update("UPDATE comment SET content = #{content}, updatedAt = NOW() WHERE commentId = #{commentId}")
    void updateComment(krhCommentVO krhcommentVo);

    // 댓글 삭제
    @Delete("DELETE FROM comment WHERE commentId = #{commentId}")
    void deleteComment(@Param("commentId") int commentId);

    // 대댓글 삭제
    @Delete("DELETE FROM comment WHERE commentId = #{commentId}")
    void deleteReply(@Param("commentId") int replyId);

    // 댓글 정보 조회 (작성자 확인용)
    @Select("SELECT * FROM comment WHERE commentId = #{commentId}")
    krhCommentVO findByCommentId(@Param("commentId") int commentId);

    // 댓글을 삭제된 상태로 업데이트 (답글이 있을 때)
    @Update("UPDATE comment SET content = '해당 댓글의 작성자가 댓글을 삭제하였습니다.', author = NULL, createdAt = NULL " +
            "WHERE commentId = #{commentId}")
    void updateCommentToDeleted(@Param("commentId") int commentId);

    // 대댓글 수정
    @Update("UPDATE comment SET content = #{content}, updatedAt = NOW() WHERE commentId = #{commentId}")
    void updateReply(krhCommentVO krhcommentVo);

    // 단건 조회 (대댓글)
    @Select("SELECT * FROM comment WHERE commentId = #{replyId}")
    krhCommentVO getCommentById(@Param("replyId") int replyId);
}
