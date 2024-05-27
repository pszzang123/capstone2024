# 의류 정렬

## 목차

- [구성](#구성)
- [Request](#request)
- [Response](#response)

## 구성

<table>
<tr>
  <td>HTTP 메서드</td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
</tr>
<tr>
  <td>API</td>
  <td>

  `/api/clothes/sort/{sortId}`

  </td>
</tr>
<tr>
  <td>Request Body</td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
</tr>
<tr>
  <td>Response Body</td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
</tr>
</table>

## Request

#### Value Type 
<table>
<tr>
  <th>key</th>
  <th>value type</th>
</tr>
<tr>
    <td>clothesId</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>name</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
<tr>
    <td>price</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>companyName</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
<tr>
    <td>imageUrl</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
</table>

<br/>

```json
[
    {
        "clothesId": ,
        "name": "",
        "price": ,
        "companyName": "",
        "imageUrl": ""
    }
]
```

<br/>

## Response

#### Value Type 
<table>
<tr>
  <th>key</th>
  <th>value type</th>
</tr>
<tr>
    <td>clothesId</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>name</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
<tr>
    <td>price</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>companyName</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
<tr>
    <td>imageUrl</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
</table>

<br/>

```json
[
    {
        "clothesId": ,
        "name": "",
        "price": ,
        "companyName": "",
        "imageUrl": ""
    }
]
```

<br/>
