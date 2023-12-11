package com.tothanhhai.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "person")
public class Person {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "name")
    private String name;
    
    @Column(name = "age")
    private Integer age;

	public Object getName() {
		// TODO Auto-generated method stub
		return null;
	}

	public Object getAge() {
		// TODO Auto-generated method stub
		return null;
	}

	public void setName(Object name2) {
		// TODO Auto-generated method stub
		
	}

	public void setAge(Object age2) {
		// TODO Auto-generated method stub
		
	} }

