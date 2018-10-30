<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <style type="text/css">
        .textbox
        {
            height: 20px;
            width: 142px;
        }
        #Select1
        {
            width: 139px;
        }
        #Select2
        {
            width: 143px;
        }
        .style1
        {
        }
        .style2
        {
            width: 247px;
        }
        .style3
        {
            width: 155px;
        }
    </style>
     <script type="text/javascript" language="javascript">
        function SucceedGetActHrs(result, usercontext) {
            if (result == 0)
            {result = "";}
            usercontext.value = result.toString();

        }

        function SucceedSumActiv(result, usercontext) {
            alert(result + usercontext);
        }

        function SucceededCallbackInsert(result) {
            alert(result.toString());
        }

        function myfunc() {
            alert('massage');
        }

        function SucceededCallback(result) {
            var res = result.length;

            var list = document.getElementById("showtble");
            list.removeChild(list.childNodes[0]);

            var body = document.getElementsByTagName('body')[0];
            var tdshowtble = document.getElementById('showtble');

            //tdshowtble.parentNode.removeChild(tdshowtble);

            var tbl = document.createElement('table');


            tbl.setAttribute('id', 'mytable');
            tbl.style.width = '100%';
            tbl.setAttribute('border', '1');
            var tbdy = document.createElement('tbody');

            var months = document.getElementById('SelectMonths');
            var years = document.getElementById('SelectYear');
            //alert(months.selectedIndex + 1);

            var month = months.options[months.selectedIndex].text;
            var year = years.options[years.selectedIndex].text;

            //WebService.HelloWorld(SucceededCallback);

            //alert(daysInMonth(month, year));

            var m = daysInMonth(month, year);

            for (var i = 0; i < res+1; i++) {
                var tr = document.createElement('tr');
                for (var j = 0; j < m + 1; j++) {
                    var td = document.createElement('td');
                    var text = document.createElement('input');

                    //////////////////////////////////////////////////////////
                    // j --- day 
                    //result[i-1] ---activity
                    //month
                    //year
                    //////////////////////////////////////////////////////////
                    if (i == 0 && j > 0) {

                        text.style.width = '30px';
                        //text.appendChild(document.createTextNode('hdhsh'));
                        //td.appendChild(text);
                        text.setAttribute('value', j);
                        text.setAttribute('disabled', 'disabled');
                    }
                    else if(i != 0 && j !=0) {
                    text.style.width = '20px';
                    text.style.color = "red";
                    text.setAttribute("maxlength", '1');
                    text.setAttribute('type', 'text');
                    text.setAttribute('class', j);
                   // text.setAttribute('onclick', alert('parent'));
                    text.setAttribute('id', 'Text' + i + j);
                    //text.setAttribute('onkeypress', myFunction(this.value));
                    //text.setAttribute('onkeyup', 'insertActihrs(this,' + i + ',' + j + ',' + month + ',' + year + ')');
                    text.setAttribute('onkeyup', 'selectActhrs(this,' + i + ',' + j + ',' + month + ',' + year + ','+res+')');
                    // text.onblur = myfun();

                    WebService.GetActivityHours(i, j, month, year, SucceedGetActHrs, null, text);

                    //text.setAttribute('value', '0');
                    
                    //////////////////////////////////////////////////////////////////////////////////////////////////
                    //WebService.InsertEmpDetails(result[i - 1].toString(), j, month, year, 8, SucceededCallbackInsert);
                    //////////////////////////////////////////////////////////////////////////////////////////////////

                    }
                    /////////////////////////////////////////////////////////
                    if (j == 0 && i > 0) {
                        text.style.width = '60px';
                        text.setAttribute('value', result[i-1].toString());
                        text.setAttribute('disabled', 'disabled');
                        //text.innerText = rs.fields(1);
                    }
                    /////////////////////////////////////////////////////////
                    if (i == 0 && j == 0) {
                        text.style.width = '60px';
                        text.setAttribute('value', 'Actv/days');
                        text.setAttribute('disabled', 'disabled');

                    }
                    /////////////////////////////////////////////////////////
                    //                    if (i == 0 && j == 0 ) {
                    //                        break
                    //                    } else {

                    //td.innerText = rs.fields(1);
                    //td.appendChild(document.createTextNode('\u0020'))                    
                    //text.appendChild(document.createTextNode(rs.fields(1)));

                    td.appendChild(text);
                    //i == 0 && j == 0 ? td.setAttribute('rowSpan', '3') : null;
                    tr.appendChild(td)
                    //  }
                }
                tbdy.appendChild(tr);
            }
            tbl.appendChild(tbdy);
            tdshowtble.appendChild(tbl);
            // tdshowtble.replaceChild(tbl, tbl.firstChild);
            //body.appendChild(tbl);  
        }

        function daysInMonth(month, year) {
            return new Date(year, month, 0).getDate();
        }
      
        function ShowAll() {
            WebService.GetActivities(SucceededCallback);
        }

        function LoadHrs(s, act, d, m, y) {
            if (act == 1)
            {alert('hellooo');}
        }

        function selectActhrs(s, act, d, m, y,res) {
            var elements = document.getElementsByClassName(d);
            var sum = 0;
            for (var i = 0; i < res; i++) {
                if (elements[i].value != "" && elements[i].value != 8) {
                    
                    sum += parseInt(elements[i].value);
                }
                else if (elements[i].value == 8) {
                    alert('Sorry not logic and other activities ??!!');
                    elements[i].value = "";
                }

                //if (sum > 8)
                //{ alert('Noo! Sum of Hours greater than 8!'); elements[i].value = ""; }
                if (i == res - 1) {
                    if (sum > 8) {
                        alert('No! Sum of Hours greater than 8!');
                        //elements[i].focus();
                        //elements[i].value = "";
                    }
                    else if (sum < 8) {
                        alert('Sum of Hours still less than 8');
                        //elements[i].value = "";
                    }
                    else if (sum == 8) {
                        for (var i = 0; i < res; i++) {
                            insertActihrs(elements[i], i + 1, d, m, y);
                        }

                    }
                }
                else if(i != res-1){
                    if (sum > 8) {
                        //alert('No! Sum of Hours greater than 8!');
                        //elements[i].focus();
                        //elements[i].value = "";
                    }
                    else if (sum == 8) {
                        for (var i = 0; i < res; i++) {
                            insertActihrs(elements[i], i + 1, d, m, y);
                        }
                    }
                }
            }
    }
    
        function insertActihrs(s, act, d, m, y) {
            WebService.InsertEmpDetails(act, d, m, y, s.value, SucceededCallbackInsert);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <script type="text/javascript">
            window.onload = function () {
                ShowAll();
            }
        </script>
        <asp:ScriptManager runat="server" ID="scriptManager">
                <Services>
                    <asp:ServiceReference path="WebService.asmx" />
                </Services>
        </asp:ScriptManager>
        <div>        
            <table style="width:100%;">
                <tr>
                <td class="style3">
                    Month
                <select id="SelectMonths" name="D1">
                <option>1</option>
                <option>2</option>
                <option>3</option>
                <option>4</option>
                <option>5</option>
                <option>6</option>
                <option>7</option>
                <option>8</option>
                <option>9</option>
                <option>10</option>
                <option>11</option>
                <option>12</option>
                </select>
                </td>
                <td class="style2">
                    Year 
                    <select id="SelectYear" name="D2">
                    <option>2014</option>
                    <option>2015</option>
                    <option>2016</option>
                    </select>
                </td>
                <td>
                    <input id="showall" type="button" value="Show"  onclick="ShowAll()" />
                </td>
                </tr>           
                <tr>
                <td id="showtble" class="style1" colspan="3">&nbsp;</td>
                <td></td>
                <td></td>
            </tr>
            </table>       
             <br />
            <table id="myTable"></table>
        </div>
    </form>
</body>
</html>
