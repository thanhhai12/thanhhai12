package com.tothanhhai.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tothanhhai.entity.Person;

public interface PersonRepository extends JpaRepository<Person, Long> {
}
