{
    This file is part of the MWA JPEG COMPONENT LIBRARY.

    The MWA JPEG COMPONENT LIBRARY is free software: you can redistribute it
    and/or modify it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The MWA JPEG COMPONENT LIBRARY is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with the MWA JPEG COMPONENT LIBRARY.  If not, see <https://www.gnu.org/licenses/>.
}
{ $Id: macros.pas,v 1.1 2007-08-13 22:00:20 tony Exp $}
{$IFDEF VER80}
{$A+,B-,E+,F-,G+,I-,K+,N-,P+,Q-,R-,S-,T-,U+,V+,W-,X+,Z-}
{$ELSE}
{$A+,B-,H+,I-,O+,P+,Q-,R-,T-,U+,V+,W-,X+}
{$ENDIF}
(*-------------------------------------------------------------------------------------*)
(*                                                                                     *)
(*               Unit: macros - a collection of useful inline macros                   *)
(*                                                                                     *)
(*               Copyright © McCallum Whyman Associates Ltd 1996                       *)
(*                                                                                     *)
(*               Author: Tony Whyman                                                   *)
(*                                                                                     *)
(*               Description: This module provides a number of useful inline macros    *)
(*                            for use with Borland Pascal and Delphi.                  *)
(*                                                                                     *)
(*-------------------------------------------------------------------------------------*)

Unit macros;

Interface
{$IFDEF VER80}
function min(a,b: integer): integer;  {If a < b Then min := a else min := b}
InLine(
  $58/          {Pop AX}
  $5B/          {Pop BX}
  $39/$D8/      {Cmp AX,BX}
  $7E/$02/      {Jle +04}
  $87/$C3);     {Xchg AX,BX}

function max(a,b: integer): integer; {If a> b Then max := a Else max := b}
InLine(
  $58/          {Pop AX}
  $5B/          {Pop BX}
  $39/$D8/      {Cmp AX,BX}
  $7D/$02/      {Jge +04}
  $87/$C3);     {Xchg AX,BX}

function MinLong(a, b: longint):longint; {If a < b Then MinLong := a Else MinLong := b}
Inline(
  $58/                    {POP     AX}
  $5A/                    {POP     DX}
  $5B/                    {POP     BX}
  $59/                    {POP     CX}
  $39/$D1/                {CMP     CX,DX}
  $7C/$06/                {JL      swap}
  $7F/$08/                {JG      exit}
  $39/$C3/                {CMP     BX,AX}
  $73/$04/                {JNB      exit}
  $89/$D8/                {MOV     AX,BX}
  $89/$CA);               {MOV     DX,CX}

function MaxLong(a, b: longint):longint; {If a < b Then MaxLong := b Else MaxLong := a}
Inline(
  $58/                    {POP     AX}
  $5A/                    {POP     DX}
  $5B/                    {POP     BX}
  $59/                    {POP     CX}
  $39/$CA/                {CMP     DX,CX}
  $7C/$06/                {JL      swap}
  $7F/$08/                {JG      exit}
  $39/$D8/                {CMP     AX,BX}
  $73/$04/                {JNB     exit}
  $89/$D8/          {swap: MOV     AX,BX}
  $89/$CA);               {MOV     DX,CX}

Implementation
{$ELSE}


function min(a,b: integer): integer;  {If a < b Then min := a else min := b}
function max(a,b: integer): integer; {If a> b Then max := a Else max := b}
function MinLong(a, b: longint):longint; {If a < b Then MinLong := a Else MinLong := b}
function MaxLong(a, b: longint):longint; {If a < b Then MaxLong := b Else MaxLong := a}

Implementation

function min(a,b: integer): integer;
Begin
     If a < b Then min := a else min := b
End;

function max(a,b: integer): integer;
Begin
     If a> b Then max := a Else max := b
End;

function MinLong(a, b: longint):longint;
Begin
     If a < b Then MinLong := a Else MinLong := b
End;

function MaxLong(a, b: longint):longint;
Begin
     If a < b Then MaxLong := b Else MaxLong := a
End;

{$ENDIF}
End.

