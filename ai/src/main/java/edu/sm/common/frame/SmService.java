package edu.sm.common.frame;

import org.springframework.transaction.annotation.Transactional;

import java.util.List;

//SmService<V,K>는 **제네릭(Generic)**을 사용하여 어떤 종류의 데이터든 처리할 수 있도록 만들어졌어요

//register(V v): 새로운 데이터를 등록하거나 생성하는 기능입니다.

//modify(V v): 기존 데이터를 수정하는 기능입니다.

//remove(K k): 특정 키(k)를 가진 데이터를 삭제하는 기능입니다.

//get(): 모든 데이터를 조회하는 기능입니다.

//get(K k): 특정 키(k)를 가진 데이터를 조회하는 기능입니다.


//@Transactional의 역할
//@Transactional은 **트랜잭션(Transaction)**을 관리해주는 스프링의 기능입니다.
//트랜잭션은 여러 개의 데이터베이스 작업이 하나의 단위로 묶여서 처리되도록 보장해줍니다. 예를 들어, 은행 송금 시 '내 통장에서 돈을 빼고' '상대방 통장으로 돈을 넣는' 두 가지 작업이 모두 성공하거나, 둘 다 실패하도록 만드는 것이죠.
//이 코드는 register, modify, remove 같은 데이터 변경 작업에 @Transactional을 붙여서, 작업 도중에 오류가 발생하면 모든 변경 내용을 취소(롤백)하도록 설정합니다. 이는 데이터의 일관성과 안정성을 보장하는 아주 중요한 기능입니다.


public interface SmService<V,K> {
    @Transactional
    void register(V v) throws Exception;
    @Transactional
    void modify(V v) throws Exception;
    @Transactional
    void remove(K k) throws Exception;
    List<V> get() throws Exception;
    V get(K k) throws Exception;
}