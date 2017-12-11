package Bean;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author Loyd
 */
public abstract class BeanBDAccess extends SQLException implements EnumSGBD{
    protected String login;
    protected String motDePasse;
    protected String nom;
    protected Connection connect = null;
    protected Class driver = null;
    protected Statement instruc = null;
    protected ResultSet rs = null;
    protected SGBD BD = null;
    
    public BeanBDAccess(String log, String mdp, SGBD baseDeDonnee)
    {
        login = log;
        motDePasse = mdp;
        BD = baseDeDonnee;
        nom = null;
       
        try
        {
            switch(baseDeDonnee)
            {
                case Oracle: driver = Class.forName("oracle.jdbc.driver.OracleDriver");
                                  break;
                                  
                case SQL: driver = Class.forName("weblogic.jdbc.mssqlserver4.Driver");
                          break;
            }
        }

        catch ( ClassNotFoundException e )
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }
    }
    
    public BeanBDAccess(String n, String log, String mdp, SGBD baseDeDonnee)
    {
        login = log;
        motDePasse = mdp;
        BD = baseDeDonnee;
        nom = n;
       
        try
        {
            switch(baseDeDonnee)
            {
                case Oracle: driver = Class.forName("oracle.jdbc.driver.OracleDriver");
                                  break;
                                  
                case SQL: driver = Class.forName("weblogic.jdbc.mssqlserver4.Driver");
                          break;
            }
        }

        catch ( ClassNotFoundException e )
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }
    }
    
    public String getLogin()
    {
        return login;
    }
    
    public String getNom()
    {
        return nom;
    }
    
    public abstract String executeRequete(String tableName, String columnName, String condition) throws SQLException;
    public abstract String[] executeRequete(String requete) throws SQLException;
    public abstract void executeUpdate(String tableName, String columnName, String update, String condition) throws SQLException;
    public abstract void executeUpdate(String requete) throws SQLException;
    public abstract String executeInsert(String requete) throws SQLException;
}
