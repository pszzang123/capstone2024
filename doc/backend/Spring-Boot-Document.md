# Spring Boot Document

## 📋목차

1. [프로젝트 구성](#프로젝트-구성)
2. [ERD](#erd)
3. [REST API](#rest-api)
4. [개선점](#개선점)

## 📋프로젝트 구성

이미지

<br/>

## 📋ERD

이미지

<br/>

## 📋REST API

1. [Customer](#customer)

<div>
<table>

<tr>
<th>API</th>
<th>HTTP 메서드</th>
<th>Request Body</th>
<th>Response Body</th>
<th>기능</th>
</tr>

<tr>
<td colspan="5">

### Customer

</td>
</tr>

<tr>
  <td>

  `/api/customers`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/customers/createCustomer.md">회원 가입</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/customers/getCustomerByEmail.md">회원 정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/{email}/{password}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/boolean-grey">
  </td>
  <td>
    <a href="./api/customers/checkCustomerByLoginInfo.md">로그인 정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/email/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/boolean-grey">
  </td>
  <td>
    <a href="./api/customers/checkCustomerByEmail.md">이메일 중복 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/customers/getAllCustomers.md">모든 회원 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/customers/updateCustomer.md">회원 정보 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/customers/deleteCustomer.md">회원 탈퇴</a>
  </td>
</tr>

</table>
</div>


<br/>

## 📋개선점
1. 권한 추가