# 🔧 Banco de Dados — Oficina Mecânica

Projeto desenvolvido como parte do desafio de modelagem e implementação de banco de dados relacional para o contexto de uma **oficina mecânica**.

---

## 📐 Esquema Lógico

### Entidades e Atributos

| Tabela | Descrição |
|---|---|
| `Cliente` | Pessoa física proprietária dos veículos |
| `Veiculo` | Automóvel associado a um cliente |
| `Mecanico` | Profissional que executa os serviços |
| `Equipe` | Grupo de mecânicos responsável por atender OS |
| `Equipe_Mecanico` | Associativa N:M entre Equipe e Mecânico |
| `Servico` | Catálogo de serviços de mão-de-obra oferecidos |
| `Peca` | Catálogo de peças com preço e estoque |
| `Ordem_Servico` | Registro central do atendimento (OS) |
| `OS_Servico` | Serviços executados dentro de uma OS (N:M) |
| `OS_Peca` | Peças utilizadas dentro de uma OS (N:M) |

### Diagrama de Relacionamentos (simplificado)

```
Cliente ──< Veiculo ──< Ordem_Servico >── Equipe >──< Mecanico
                             │
                    ┌────────┴────────┐
                    ▼                 ▼
               OS_Servico         OS_Peca
                    │                 │
                Servico            Peca
```

### Relacionamentos principais

- Um **Cliente** pode possuir N **Veículos**.
- Um **Veículo** pode ter N **Ordens de Serviço** ao longo do tempo.
- Cada **OS** é atribuída a uma **Equipe**.
- Uma **Equipe** é composta por N **Mecânicos** (N:M via `Equipe_Mecanico`).
- Uma **OS** pode conter N **Serviços** (N:M via `OS_Servico`).
- Uma **OS** pode consumir N **Peças** (N:M via `OS_Peca`), com o preço unitário registrado no momento da OS para histórico fiel.

---

## 📁 Estrutura do projeto

```
oficina_db.sql   ← DDL + DML + Queries
README.md        ← Este arquivo
```

---

## 🗄️ Como executar

```bash
# MySQL / MariaDB
mysql -u root -p < oficina_db.sql

# Ou dentro do cliente:
source oficina_db.sql;
```

---

## 🔍 Queries implementadas

| # | Cláusulas | Pergunta respondida |
|---|---|---|
| Q1 | `SELECT`, `ORDER BY` | Todos os clientes em ordem alfabética |
| Q2 | `WHERE`, `IN` | OS com status "Em andamento" ou "Aguardando" |
| Q3 | Atributo derivado, `GROUP BY` | Valor total de peças por OS |
| Q4 | Atributo derivado, `WHERE` | Veículos com mais de 5 anos e km médio anual |
| Q5 | `ORDER BY`, `CASE` | Mecânicos por faixa salarial decrescente |
| Q6 | `JOIN`, `GROUP BY`, `HAVING` | Clientes com mais de 1 veículo |
| Q7 | `JOIN`, `HAVING` | Serviços solicitados em 2 ou mais OS |
| Q8 | `JOIN` múltiplo | Histórico de OS com dados do cliente e veículo |
| Q9 | `JOIN` complexo, atributo derivado | Valor total (mão-de-obra + peças) por OS concluída |
| Q10 | `JOIN`, `HAVING`, `ORDER BY` | Clientes que gastaram mais de R$500 |
| Q11 | `JOIN`, Window Function (`OVER`) | Composição e custo total por equipe |
| Q12 | Subquery, `JOIN`, `WHERE` | Peças mais usadas com estoque baixo |
| Q13 | `JOIN`, `GROUP BY`, `HAVING`, `AVG` | Produtividade por equipe (OS e tempo médio) |

---

## 🛠️ Tecnologias

- **SGBD:** MySQL 8+ / MariaDB 10.6+
- **Linguagem:** SQL (DDL + DML)
- **Encoding:** UTF-8 mb4

---

## 👤 Autor

Desenvolvido como desafio de projeto — módulo de Modelagem e Banco de Dados.
