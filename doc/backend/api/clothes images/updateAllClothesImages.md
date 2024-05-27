# 모든 의류 이미지 변경

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

  `/api/clothes_images`

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
    <td>imageUrl</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
<tr>
    <td>order</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
</table>

<br/>

```json
[
    {
        "clothesId": ,
        "imageUrl": "",
        "order": 
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
    <td>imageUrl</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
<tr>
    <td>order</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
</table>

<br/>

```json
[
    {
        "clothesId": ,
        "imageUrl": "",
        "order": 
    }
]
```

<br/>
