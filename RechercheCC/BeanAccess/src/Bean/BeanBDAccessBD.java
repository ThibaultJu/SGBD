/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Bean;

import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Loyd
 */
public final class BeanBDAccessBD extends BeanBDAccess {

    public BeanBDAccessBD(String log, String mdp, SGBD baseDeDonnee)
    {
        super(log, mdp, baseDeDonnee);
    }
    
    @Override
    public String executeRequete(String tableName, String columnName, String condition) throws SQLException {
        int cpt;
        String resultat = null;
        
        if(driver != null)
        {
            try
            {
                if(login != null)
                {
                    resultat = new String();
                    connect = DriverManager.getConnection("jdbc:oracle:thin:BD@//localhost:1521/orcl", login, motDePasse);
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
    public String[] executeRequete(String requete) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void executeUpdate(String tableName, String columnName, String update, String condition) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void executeUpdate(String requete) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String executeInsert(String requete) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
