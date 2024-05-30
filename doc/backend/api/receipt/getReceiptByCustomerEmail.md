# 회원 영수증 확인

## 목차

- [구성](#구성)
- [Request](#request)
- [Response](#response)

## 구성

<table>
<tr>
  <td>HTTP 메서드</td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
</tr>
<tr>
  <td>API</td>
  <td>

  `/api/receipt/{email}`

  </td>
</tr>
<tr>
  <td>Request Body</td>
  <td>
    .
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

```json

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
    <td>receiptId</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>customerEmail</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
<tr>
    <td>status</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>date</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
</table>

<br/>

```json
[
    {
        "receiptId": ,
        "customerEmail": "",
        "status": ,
        "date": ""
    }
]
```

<br/>
