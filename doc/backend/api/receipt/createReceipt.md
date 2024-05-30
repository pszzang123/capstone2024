# 영수증 추가

## 목차

- [구성](#구성)
- [Request](#request)
- [Response](#response)

## 구성

<table>
<tr>
  <td>HTTP 메서드</td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
</tr>
<tr>
  <td>API</td>
  <td>

  `/api/receipt`

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
    <td>customerEmail</td>
    <td><img src="https://img.shields.io/badge/string-grey"></td>
</tr>
<tr>
    <td>status</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
</table>

<br/>

```json
{
    "customerEmail": "",
    "status": 
}
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
</table>

<br/>

```json
{
    "receiptId": ,
    "customerEmail": "",
    "status": 
}
```

<br/>
