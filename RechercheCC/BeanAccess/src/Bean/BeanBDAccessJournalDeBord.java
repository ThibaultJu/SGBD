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
public class BeanBDAccessJournalDeBord extends BeanBDAccess {
    
    public BeanBDAccessJournalDeBord(String log, String mdp, SGBD baseDeDonnee)
    {
       super(log, mdp, baseDeDonnee);
    }
    
    @Override
    public String executeRequete(String tableName, String columnName, String condition) throws SQLException
    {
        int cpt;
        String resultat = null;
        
        if(driver != null)
        {
            try
            {
                if(login != null)
                {
                    resultat = new String();
                    connect = DriverManager.getConnection("jdbc:oracle:thin:BD_JOURNALDEBORD@//localhost:1521/orcl", login, motDePasse);
                    instruc = connect.createStatement();

                    if( condition == null)
                        rs = instruc.executeQuery("select " + columnName + " from " + tableName);
                    else
                        rs = instruc.executeQuery("select " + columnName + " from " + tableName + " where " + condition);

                    while(rs.next())
                    {
                        cpt = 1;
                        while(cpt-1 < rs.getMetaData().getColumnCount())
                        {
                            resultat += rs.getString(cpt);
                            cpt++;
                        }
                    }
                }

            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
        
        return resultat;
    } 
    
    @Override
    public String[] executeRequete(String requete) throws SQLException
    {
        int cpt = 1;
        String resultat = null;
        String []ret = null;
        
        if(driver != null)
        {
            try
            {
                if(login != null)
                {
                    resultat = new String();
                    connect = DriverManager.getConnection("jdbc:oracle:thin:BD_JOURNALDEBORD@//localhost:1521/orcl", login, motDePasse);
                    instruc = connect.createStatement();

                    rs = instruc.executeQuery(requete);

                    while(rs.next())
                    {
                        cpt = 1;
                        while(cpt-1 < rs.getMetaData().getColumnCount())
                        {
                            resultat += rs.getString(cpt) + System.getProperty("line.separator");
                            cpt++;
                        }
                    }
                    
                    if(cpt != 1)
                    {
                        ret = new String[cpt];
                        ret = resultat.split("&&");
                    }
                }
            }
        
            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
        
        return ret;
    }
    
    @Override
    public void executeUpdate(String tableName, String columnName, String update, String condition) throws SQLException
    {       
        if(driver != null)
        {
            try
            {
                if(login != null)
                {
                    connect = DriverManager.getConnection("jdbc:oracle:thin:BD_JOURNALDEBORD@//localhost:1521/orcl", login, motDePasse);
                    instruc = connect.createStatement();

                    if(condition == null)
                        instruc.executeUpdate("update " + tableName + " set " + columnName + " = " + columnName + update);
                    else
                        instruc.executeUpdate("update " + tableName + " set " + columnName + " = " + columnName + update + " where " + condition);
                } 
            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
    }
    
    @Override
    public String executeInsert(String requete) throws SQLException
    {
        String resultat = null;
        
        if(driver != null)
        {
            try
            {
                if(login != null && driver != null)
                {
                    synchronized(this)
                    {
                        resultat = new String();
                        connect = DriverManager.getConnection("jdbc:oracle:thin:BD_JOURNALDEBORD@//localhost:1521/orcl", login, motDePasse);
                        instruc = connect.createStatement();

                        instruc.executeUpdate(requete);
                    }     
                }
            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
        
        return resultat;
    }
    
    @Override
    public void executeUpdate(String requete) throws SQLException
    {
        if(driver != null)
        {
            try
            {
                if(login != null)
                {
                    connect = DriverManager.getConnection("jdbc:oracle:thin:BD_JOURNALDEBORD@//localhost:1521/orcl", login, motDePasse);
                    instruc = connect.createStatement();

                    instruc.executeUpdate(requete);     
                }
            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
    }
}
