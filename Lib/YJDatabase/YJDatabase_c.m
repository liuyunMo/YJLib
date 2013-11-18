//
//  YJDatabase_c.c
//  TestYJFramework
//
//  Created by szfore on 13-5-30.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "YJDatabase_c.h"
void freeYJColumn(YJColumnRef column)
{
    if (column) {
        SAFE_FREE(column->name);
        SAFE_FREE(column);
    }
}
YJStatus openDatabase(const char *path,sqlite3 **sqlite)
{
    if (sqlite3_open(path, sqlite)!=SQLITE_OK)
    {
        sqlite3_close(*sqlite);
        printf("打开数据库失败！\n");
        return YJDATABASE_FAIL;
    }
    return YJDATABASE_OK;
}
YJStatus closeDatabase(sqlite3 *database)
{
    if (sqlite3_close(database)==SQLITE_OK)return YJDATABASE_OK;
    return YJDATABASE_FAIL;
}
YJStatus handleWithSql(const char *sql,sqlite3 *database)
{
    char *errorMeg=NULL;
    if (sqlite3_exec(database, sql, NULL, NULL, &errorMeg)!=SQLITE_OK)
    {
        printf("error:%s\nsql:%s\n",errorMeg,sql);
        return YJDATABASE_FAIL;
    }
    return YJDATABASE_OK;
}
YJStatus getIntValueWithSql(const char *sql,int *value,sqlite3 *database)
{
    sqlite3_stmt *stmt=NULL;
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)==SQLITE_OK) {
        
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            if (sqlite3_column_text(stmt, 0))
            {
                *value=sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                return YJDATABASE_OK;
            }
        }
    }
    sqlite3_finalize(stmt);
    return YJDATABASE_FAIL;
}
YJStatus copyStrVaueWithSql(const char *sql,char **value,sqlite3 *database)
{
    sqlite3_stmt *stmt=NULL;
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)==SQLITE_OK) {
        
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            if (sqlite3_column_text(stmt, 0))
            {
                const char *value_db=(const char *)sqlite3_column_text(stmt, 0);
                *value=(char*)malloc(strlen(value_db)+1);
                strcpy(*value, value_db);
                break;
            }
        }
    }else{
        sqlite3_finalize(stmt);
        return YJDATABASE_FAIL;
    }
    sqlite3_finalize(stmt);
    return YJDATABASE_OK;
}
YJStatus copyAllTableName(sqlite3 *database,YJStringRef *tableNames)
{
    YJStringRef str=NULL;
    const char *sql="SELECT name FROM sqlite_master WHERE type = \"table\";";
    sqlite3_stmt *stmt=NULL;
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)==SQLITE_OK) {
        
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            if (sqlite3_column_text(stmt, 0))
            {
                if (!str)
                {
                    str=createYJString((const char*)sqlite3_column_text(stmt, 0));
                }else{
                    addString(str, (const char*)sqlite3_column_text(stmt, 0));
                }
            }
        }
    }else{
        sqlite3_finalize(stmt);
        return YJStatusFail;
    }
    *tableNames=str;
    sqlite3_finalize(stmt);
    return YJStatusOK;
}
YJStatus copyAllColumnFromTable(sqlite3 *database,YJStringRef *column,const char *tableName)
{
    YJStringRef str=NULL;
    YJStatus result=YJDATABASE_FAIL;
    const char *_sql="SELECT * FROM sqlite_master WHERE type = \"table\" AND name='";
    const char *sql_="';";
    char *sql=(char *)malloc(strlen(_sql)+strlen(sql_)+strlen(tableName)+1);
    strcat(sql, _sql);
    strcat(sql, tableName);
    strcat(sql, sql_);
    sqlite3_stmt *stmt=NULL;
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)==SQLITE_OK) {
        
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            if (sqlite3_column_text(stmt, 1))
            {
                if (!str)
                {
                    str=createYJString((const char*)sqlite3_column_text(stmt, 1));
                }else{
                    addString(str, (const char*)sqlite3_column_text(stmt, 1));
                }
            }
        }
        result= YJStatusOK;
    }else{
        result= YJStatusFail;
    }
    free(sql);
    sqlite3_finalize(stmt);
    *column=str;
    return result;
}
YJColumnRef createYJColumnWithCreateSql(const char *createSql,int *columnCount)
{
    char *dl="(";
    char *list=strtok((char *)createSql,dl);
    if (list) list=strtok(NULL, dl);
    
    list[strlen(list)-1]='\0';//delete last char
    char *dl2=",";
    char *columnStr=strtok(list, dl2);
    while (columnStr) {
        columnStr=strtok(NULL, dl2);
    }
    return NULL;
}
YJStatus getColumnCountFromTable(sqlite3 *database,int *columnCount,const char *tableName)
{
    const char *_sql="SELECT sql FROM sqlite_master WHERE type = \"table\" AND name='";
    const char *sql_="';";
    char *sql=(char *)malloc(strlen(_sql)+strlen(sql_)+strlen(tableName)+1);
    strcat(sql, _sql);
    strcat(sql, tableName);
    strcat(sql, sql_);
    YJStatus result=YJDATABASE_FAIL;
    sqlite3_stmt *stmt=NULL;
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)==SQLITE_OK) {
        
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            const char *createSql=(const char *)sqlite3_column_text(stmt, 0);
            createYJColumnWithCreateSql(createSql, columnCount);
        }
        result= YJStatusOK;
    }else{
        result= YJStatusFail;
    }
    free(sql);
    sqlite3_finalize(stmt);
    
    return result;
}
